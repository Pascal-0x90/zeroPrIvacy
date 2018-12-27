#!/bin/bash

clear
echo "###############################
###     zeroPrIvacy         ###
###    By Nathan Smith      ###
###  A Raspberry pi Project ###
###############################"

echo "Welcome!"
echo "
Remember, this could potentially mess any current configuration up
and you may have to fix this on your own. It is recommended that you
run this install script on a newly generated iso of raspbian. Otherwise,
enjoy at your own risk. Some files will be backed up but not all so be
cautious of what you need backed up. THIS WILL NOT RENDER THE PI UNUSABLE
BUT SSH MAY FAIL SINCE THIS IS ALL NETWORKING STUFF."
echo " "
echo "Do you understand? (yes/no)"

read agree

if [[ $agree == [yY]* ]];
then
# Update the system first
echo "
#####################################"
echo "Uptading and upgrading your system..."
echo "#####################################"
sudo apt update && sudo apt dist-upgrade -y

# Install some dependencies
clear
echo "###############################"
echo "Installing some dependencies..."
echo "###############################"
sudo apt install isc-dhcp-server tor lighttpd php7.0-cgi dnsmasq vnstat -y
sudo service isc-dhcp-server stop
sudo lighttpd-enable-mod fastcgi-php
sudo service lighttpd restart
sudo rm -rf /var/www/html
sudo git clone https://github.com/billz/raspap-webgui /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo mkdir /etc/raspap
sudo mv /var/www/html/raspap.php /etc/raspap/
sudo chown -R www-data:www-data /etc/raspap
clear

echo "Would you like to back up the following files?:"
echo "
/etc/network/interfaces
/etc/rc.local
/etc/sudoers
/etc/wpa_supplicant/wpa_supplicant.conf
/etc/dhcp/dhcpd.conf
/etc/default/isc-dhcp-server
/etc/sysctl.conf
/boot/config.txt
/etc/sysctl.conf
/etc/tor/torrc

(These are all files that will be changed as this device is configured)"
read backup

if [[ $backup == [yY]* ]];
then
        if [ ! -d /home/pi/zeroPrIvacy/backup ];
        then
                sudo mkdir /home/pi/zeroPrIvacy/backup
        fi
        sudo cp /boot/config.txt /home/pi/zeroPrIvacy/backup/config.txt.bak
        sudo cp /etc/modules /home/pi/zeroPrIvacy/backup/modules.bak
        sudo cp /etc/rc.local /home/pi/zeroPrIvacy/backup/rc.local.bak
        sudo cp /etc/default/isc-dhcp-server /home/pi/zeroPrIvacy/backup/isc-dhcp-server.bak
        sudo cp /etc/network/interfaces /home/pi/zeroPrIvacy/backup/interfaces.bak
        sudo cp /etc/sudoers /home/pi/zeroPrIvacy/backup/sudoers.bak
        sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /home/pi/zeroPrIvacy/backup/wpa_supplicant.conf.bak
        sudo cp /etc/dhcp/dhcpd.conf /home/pi/zeroPrIvacy/backup/dhcpd.conf.bak
        sudo cp /etc/sysctl.conf /home/pi/zeroPrIvacy/backup/sysctl.conf.bak
        sudo cp /etc/tor/torrc /home/pi/zeroPrIvacy/backup/torrc.bak
fi

# Start Copying over files to where they need to go
echo "###########################"
echo "Configuring system files..."
echo "###########################"
sudo cp /home/pi/zeroPrIvacy/config_files/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo cp /home/pi/zeroPrIvacy/config_files/iptables.ipv4.nat /etc/iptables.ipv4.nat
sudo cp /home/pi/zeroPrIvacy/config_files/rc.local /etc/rc.local
sudo cp /home/pi/zeroPrIvacy/config_files/torrc  /etc/tor/torrc
sudo cp /home/pi/zeroPrIvacy/config_files/interfaces /etc/network/interfaces
sudo cp /home/pi/zeroPrIvacy/config_files/isc-dhcp-server /etc/default/isc-dhcp-server
sudo cp /home/pi/zeroPrIvacy/config_files/sysctl.conf /etc/sysctl.conf
sudo cp /home/pi/zeroPrIvacy/config_files/sudoers /etc/sudoers
sudo chmod 700 /etc/sudoers
echo "Is your wifi successfully connected to an access point?"
read wifi
if [[ $wifi == [nN]* ]];
then
clear
echo "Okay, let's setup the wifi first."
echo "What is the SSID for your access point?"
read ssid
echo "What is the PASSPHRASE for your access point?"
read pass
echo "One moment..."
sudo cp /home/pi/zeroPrIvacy/config_files/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
sudo sh -c "wpa_passphrase '$ssid' '$pass' | cat >> /etc/wpa_supplicant/wpa_supplicant.conf"
fi
echo "###############"
echo "Enabling ssh..."
echo "###############"
update-rc.d ssh enable &&
invoke-rc.d ssh start

#clear
echo "
################################
Thank you for installing the
zeroPrIvacy configuration for
the raspberry pi zero/zero w.

The installation is done and the
pi will now reboot in 10 seconds
to complete installation.
################################"
sleep 10
sudo reboot
fi
