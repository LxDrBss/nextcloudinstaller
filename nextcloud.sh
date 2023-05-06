#!/bin/bash

#set -e

pathSSD=/media/storage
partuuid=$(blkid | grep 'sda1' | grep -o -E 'PARTUUID="[a-zA-Z|0-9|\-]*' | cut -c 11-)
mySSD=$(sudo fdisk -l | grep '\n' | grep '/dev/sd' | cut -c 1-10)

sudo echo 'ENV{UDISKS_IGNORE}="1"' > /lib/udev/rules.d/80-udisks2-noautomount.rules
sudo service udisks2 restart
sudo mkdir ${pathSSD}
sudo mount ${mySSD} ${pathSSD}
sudo chmod 646 /etc/fstab
sudo printf "PARTUUID="${partuuid}" "${pathSSD}" ext4 defaults 0 0">> /etc/fstab
sudo chmod 644 /etc/fstab
sudo chown -R www-data:www-data $pathSSD

read -p "Configuration done. Install nextcloud now? (Y/N): " input && [[ $input == [yY] ]] || echo "Bye!"; exit 1
echo "Continue with nextcloud installation. This can take little while."

curl -sSL https://raw.githubusercontent.com/nextcloud/nextcloudpi/master/install.sh | sudo bash

echo ""
echo "Installation complete. In top of this text should be more info how you can continue. Have fun!"
