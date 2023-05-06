# nextcloudinstaller

This works totally fine on my Raspberry Pi. 
Setup: 
- fully new flashed Raspberry Pi OS (use Raspberry Pi Imager for headless start)
- USB-Drive for cloud-storage. If there isn't one, you can skip and continue.

What it should do:
- disable automount from udisk (prevent random mounting your drive)
- mount USB-Drive in /media/[yourfolder] and activate automount for it on boot
- change owner from /media/[yourfolder] to www-data (necessary so that nextcloud can access it later)
- ([yourfolder] can be set in the running script)
- finally install nextcloud!

Options:
- uncomment #set -e before executing the script to exit after an error occurs

When you got any bugs, questions or wishes to fix or extend this script please let me know!

Installation:

wget https://raw.githubusercontent.com/LxDrBss/nextcloudinstaller/main/nextcloud.sh && sudo chmod +x nextcloud.sh && ./nextcloud.sh


I totally dont own or work together with nextcloud. Just had some issues with nextcloud using my USB-Drive as storage and want you all to have an easy installation.
