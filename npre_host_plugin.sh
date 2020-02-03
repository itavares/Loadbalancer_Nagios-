#!/bin/bash
# Quick install and setup for NPRE on a remote host once main server is setup

#add nagios user in host
sudo useradd nagios

#update apt-get and install dependencies

sudo apt-get update
sudo apt-get install build-essential libgd2-xpm-dev openssl libssl-dev unzip

#install Nagios plugins on remote hosts

cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar zxf nagios-plugins-*.tar.gz
cd nagios-plugins-*

#configure nagios plugins to use as nagios user and group and have SSL support
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl

#compile and install nagios-plugin
make
sudo make install

# Install NRPE
cd ~
curl -L -O https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar zxf nrpe-*.tar.gz
cd nrpe-*	

# Configure NRPE to run as Nagios user and group, and have SSL support
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu

#build and install NRPE and its default scripts
make all
sudo make install
sudo make install-config
sudo make install-init

#update NRPE configuration file
echo "Nagios Server's Private IP : "
read nagios_server_ip

sed -i "/allowed_hosts=127.0.0.1,::1/c\allowed_hosts=127.0.0.1,::1,$nagios_server_ip" "/usr/local/nagios/etc/nrpe.cfg"

#start nrpe serive and check status
sudo systemctl start nrpe.service
sudo systemctl status nrpe.serice

#add to firewall
sudo ufw allow 5666/tcp

