#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}

clear
printf "
#######################################################################
#                    Uninstall-aliyun-service                         #
#######################################################################
"

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

mkdir Uninstall-aliyun-service
chmod 777 Uninstall-aliyun-service
cd Uninstall-aliyun-service

clear
apt update
apt install redhat-lsb -y

wget https://raw.githubusercontent.com/4D4937/aliyun-service-uninstall/master/uninstall.sh
chmod +x uninstall.sh
./uninstall.sh
wget https://raw.githubusercontent.com/4D4937/aliyun-service-uninstall/master/quartz_uninstall.sh
chmod +x quartz_uninstall.sh
./quartz_uninstall.sh
pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*
rm /usr/sbin/aliyun-service
rm /lib/systemd/system/aliyun.service
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
iptables -I INPUT -s 106.11.222.0/23 -j DROP
iptables -I INPUT -s 106.11.224.0/24 -j DROP
iptables -I INPUT -s 106.11.228.0/22 -j DROP
service iptables save
rm -rf /etc/motd
wget -O /etc/motd -N --no-check-certificate https://raw.githubusercontent.com/4D4937/aliyun-service-uninstall/master/motd
cd -
rm -rf Uninstall-aliyun-service

kill -9 $(pidof AliYunDun)
kill -9 $(pidof AliYunDunUpdate)
find . -name 'agentwatch*' -type d -exec rm -rf {} \; && find . -name 'agentwatch*' -type f -exec rm -rf {} \;
find . -name 'aliyun*' -type d -exec rm -rf {} \;
find . -name 'aliyun*' -type f -exec rm -rf {} \;
find . -name 'aegis*' -type f -exec rm -rf {} \;
find . -name 'aegis*' -type d -exec rm -rf {} \;
rm -fr /usr/sbin/aliyun-service /usr/sbin/aliyun_installer
find /etc/systemd/system/ -name 'cloud-*' | xargs rm -rf
clear

printf "
#######################################################################
#                    Uninstall-aliyun-service                         #
#                                 Done!                               #
#######################################################################
"
