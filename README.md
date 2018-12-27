# zeroPrIvacy: A Raspberry PI Zero W Project
A project built for raspbian on the raspberry pi zero w for routing computer traffic through the tor network in a convienent and small(ish) package.
## What is zeroPrIvacy?
Despite the name, the project was created to allow a user to, once fully installed, be able to plug their raspberry pi zero into a computer via USB and use it as a Wifi Adapter that routes your traffic through tor. 
## How does the device work?
Of course this does use the onboard adapter that the raspberry pi zero w has (thus the w), and the usb connection either through some cable plugged into the usb micro usb connector or through some soldered/connected USB-A Male connector. The USB connection becomes an emulated RNDIS connector when plugged into a computer (Whether Linux or Windows, have not been able to test MacOS) which is a fancy way to say USB Ethernet which will use its onboard DHCP server to give the computer an ip and allow it to communicate with the pi. Then, the user can connect to an access point using the pi by using the online php api (from the RaspAP Project https://github.com/billz/raspap-webgui but I slightly modified on install).
## How to install
1) Format sd card with SD Card Formatter utility

2) Download the latest version of raspian-lite from https://www.raspberrypi.org/downloads/raspbian/. Use something such as etcher to flash the raspbian ISO to the micro SD card. (Used Raspbian Lite cause i dont need local GUI except for whatever online UI )
	
3) For this project, I started out using an FTDI breakout board to do serial to the pi using PUTTY. If you do not have this capability to run serial to the pi through some other serial connector there are some other ways for enabling serial however, the one at this link https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/serial-gadget, could possibly interfere with the usb connection.
We will need to enable uart to use serial at boot. So, before even ejecting the sd card, go ahead and do this step and setp 4 and save. 
(Keep in mind, I am doing this all in windows and of course on the pi, Linux)
In config.txt at the bottom, add the following lines:
enable_uart=1 
dtoverlay=dwc2 
	
4) Save and exit config.txt, then open the cmdline.txt and type in the following code between the last 'rootwait' and the last 'quiet':
modules-load=dwc2,g_ether

** This enables the devices as an ethernet gadget **
***I have tried the route to enable ssh from adding in a file within the "boot" partition of the sd card however, I seemed to have issues with it so I chose 
to go this route and enable it later***
	
4) Using an FTDI breakout board, I attatched the txd of the bb (breakout board) to the rxd pin on the raspberry pi then rxd of bb to txd of raspberry pi and ground to ground on both. 
	
5) The FTDI device shows as a console port on a windows laptop (with the proper device drivers installed) "COM3"
	
6) Upon it being recognized, I open up PUTTY which is a program used to offer a wide variety of network connections to different devices (telnet, ssh, serial)
*** In this case we will use Serial ***
	
7) Select the serial radial button and put in the proper COM port, Mine is COM3 as per my device manager states (Right click bottom left corner of screen > Device manager > expand the menu for COM ports to see proper COM device.)
	
8) Baudrate for most raspberry pi devices in the family run at a baudrate/speed of 115200, so change that otherwise the connection will be too fast for the computer to sense it and you will just see garbage
	
9) Most noteably here is this is a live transfer of data, so the connection may be a little touchy at times depending on your cable, make sure you are connecting with a good enough serial connection
	
10) With success, once you power the device up and all connectiomns were properly made, the console will start spitting out start up data then you will be presented with a login screen. 
	
11) Log in with Username: pi Password: raspberry
	
12) Once in , run the command 
```
sudo raspi-config
```
Select 'Network Options' > 'Wi-Fi' > Then enter in your ssid and passphrase for your access point you currently wish to use. This can be changed later if you do desire. 
	
13) You can choose to do whatever extra modifications you can however, my install script will enable ssh. 

14) If you need to reboot, reboot, otherwise lets move right along to the main install.

***Some things to keep in mind, the installer is a once and done kind of gig. Though there is a little user input just during the install (for backups, wifi config, etc.) all in all it should work pretty smoothly.***
***A lot of the functionality of this does revolve around the use of iptables. So if you do need to fix something, modify something, yadda yadda, go ahead and issue the command "sudo /etc/iptables.ipv4.nat". Then go ahead and reboot so that rc.local can initiate the new set of rules to iptables that you have added***

15) Let's install git (Cause that's probably not installed unless you already did you impatient being). Issue the command:
```
sudo apt install git -y
```
This will install git. Lets git right to it then.

16) git clone this repository within the directory ~/
```
git clone https://github.com/Xc1d30us-Mercy/zeroPrIvacy.git
```
17) You can cd into the directory. Then chmod the install.sh to make sure its an executable shell script
```
cd zeroPrIvacy/
sudo chmod a+x install.sh
```
18) Now let's hit the big red button shall we?
```
sudo ./install.sh
```
19) Follow the prompts as you go along. It will then reboot and blamo, it *should* work. 

## Resources
https://github.com/billz/raspap-webgui#-raspap-webgui--
https://github.com/wismna/HackPi
https://redmine.lighttpd.net/projects/1/wiki/TutorialConfiguration
https://twit.tv/shows/know-how/episodes/301
http://www.isticktoit.net/?p=1383
https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget
http://www.linuxandubuntu.com/home/complete-setup-tutorial-for-lighttpd-a-lightweight-web-server
https://askubuntu.com/questions/910402/how-to-allow-only-ssh-and-internet-access-with-iptables
