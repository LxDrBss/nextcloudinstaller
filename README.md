# nextcloudinstaller

This works totally fine on my Raspberry Pi. 
Setup: 
- fully new flashed Raspberry Pi OS (use Raspberry Pi Imager for headless start)
- USB-Drive connected as sda and in ext4 format (should always be sda when its the only one connected) for cloud storage

What it should do:
- disable automount from udisk (prevent random mounting your drive)
- mount USB-Drive in /media/storage and activate automount for it on boot
- change owner from /media/storage to www-data (necessary so that nextcloud can access it later)
- finally install nextcloud!


When you got any questions or wishes to extend this script please let me know!

Installation:
wget 
sudo chmod 744 nextcloud.sh
./nextcloud.sh


I totally dont own or work together with nextcloud. Just had some issues with nextcloud using my USB-Drive as storage and want you all to have an easy installation.
