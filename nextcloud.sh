#!/bin/bash

#set -e

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NORMAL='\e[0;39m'

drivesName=( $(lsblk -o NAME | grep -o "sd[a-z][0-9]" | cut -d " " -f 1))
drivesSpace=( $(lsblk -o NAME,SIZE | grep "sd[a-z][0-9]"))
declare -p drivesName >> /dev/null
declare -p drivesSpace >> /dev/null

#Start of Script

echo $'\n'
echo -e "$GREEN Welcome to nextcloudinstaller! $NORMAL"
echo $'\n'

#Disable udisks auto-mount (if not already happened)
if [[ ! -e /lib/udev/rules.d/80-udisks2-noautomount.rules ]]; then
	sudo echo 'ENV{UDISKS_IGNORE}="1"' > 80-udisks2-noautomount.rules
	sudo cp 80-udisks2-noautomount.rules /lib/udev/rules.d/
	sudo rm 80-udisks2-noautomount.rules
	sudo service udisks2 restart
fi

read -p "Do you wanna configurate an external storage device(USB)? (Y|N): " input
if [[ "$input" == [yY] ]]; then
	#Check if there is a external drive for storage connected
	if [[ ${#drivesName[@]} == 0 ]]; then
		echo "You got no external drive connected."
		read -p "Continue without configuring external drive or exit?(C|E): " input
		if [[ "$input" == "E" ]]; then exit 1; fi
	else
		echo $'\n'
		for (( i=0; i < ${#drivesName[@]}; i++ ))
		do
			echo -e "[$GREEN$i$NORMAL]Drive/Partition $RED${drivesName[$i]}$NORMAL has $YELLOW${drivesSpace[$i+1+$i]}$NORMAL Space."
		done
		echo ''
		read -p "Choose your Drive/Partition by green index number: " input
		echo ''
		partition=${drivesName[$i]}
		echo "You chose$RED $partition$NORMAL."
		echo ""
		checkMount=( $(lsblk -o NAME,MOUNTPOINT | grep "$partition"))
		declare -p checkMount >> /dev/null
		if [[ ${checkMount[1]} == "" ]]; then
			read -p "Now name folder which your device will be mounted: " input
			if [[ -e /media/$input ]]; then echo ""; echo "This folder already exists."; echo ""; fi
			mountPath=/media/$input
			echo ""
			echo -e "Your external drive is mounted in $RED$mountPath$NORMAL"
			sudo mkdir $mountPath
			sudo mount /dev/$partition $mountPath
			partUUID=$(sudo blkid | grep "$partition" | grep -o -E 'PARTUUID="[a-zA-Z|0-9|\-]*' | cut -c 11-)
			getFormat=( $(sudo lsblk -f -o NAME,FSTYPE | grep "$partition"))
			declare -p getFormat >> /dev/null
			format=${getFormat[1]}
			sudo chmod 646 /etc/fstab
			sudo printf "PARTUUID="$partUUID" "$mountPath" $format defaults 0 0">> /etc/fstab
			sudo chmod 644 /etc/fstab
			sudo chown -R www-data:www-data $mountPath
		else
			printf "$RED"; echo -e "$partition $NORMAL is already mounted in$YELLOW ${checkMount[1]} $NORMAL"; echo ""
		fi
	fi
fi


read -p "Configuration done. Install nextcloud now? (Y|N): " input && [[ $input == [yY] ]] || echo "Bye!"; exit 1
echo -e "$YELLOWContinue with nextcloud installation. This can take little while. $NORMAL"

sudo curl -sSL https://raw.githubusercontent.com/nextcloud/nextcloudpi/master/install.sh | sudo bash

echo ""
echo -e "$GREEN Installation complete. In top of this text should be more info how you can continue. Have fun! $NORMAL"
