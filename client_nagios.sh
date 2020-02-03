#!/bin/bash
# add configurations needed to set up a new client with nagios server
echo "Input monitored server host name: "
read mshn

#sudo touch ${mshn}.cfg

echo "Input Client Server Alias: "
read csalias

echo "Input Monitored Server Private Ip :  "
read mspi

sudo echo "
define host {
    	use                         	linux-server
    	host_name                   	$mshn
    	alias                       	$csalias
    	address                     	$mspi
    	max_check_attempts          	5
    	check_period                	24x7
    	notification_interval       	30
    	notification_period         	24x7
}

define service {
    	use                         	generic-service
    	host_name                   	$mshn
    	service_description         	CPU load
    	check_command               	check_nrpe!check_load
}

" > /usr/local/nagios/etc/servers/${mshn}.cfg
