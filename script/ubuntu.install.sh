#!/bin/bash

POSSIBLETARGET=("1-preinstall" "2-mysql" "3-nginx" )
dumphelp(){
        echo "sudo $0 <target>"
        echo "possible target: `printf '\n\t%s' "${POSSIBLETARGET[@]}"`"
        exit 1
}

if [ $# -ne 1 ]; then
        dumphelp
fi

if [ $1 = "1-preinstall" ]; then
	apt-get -y install vim-nox
	apt-get update
	apt-get upgrade
	read -p "A reboot is required.  Reboot Now?" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    reboot
	fi
elif [ $1 = "2-mysql" ]; then
	apt-get -y install mysql-client mysql-server
	sed -i.bak -f mysql.sed /etc/mysql/my.cnf
	/etc/init.d/mysql restart
elif [ $1 = "3-nginx" ]; then
	apt-get -y install nginx
	apt-get -y install php-fpm
	apt-get -y install php-mysql
	apt-get -y install fcgiwrap
	apt-get -y install phpmyadmin

	sed -i.bak -f nginx.sed /etc/php/7.0/fpm/pool.d/www.conf
	/etc/init.d/nginx start
	/etc/init.d/php7.0-fpm restart
	cp nginx/* /etc/nginx/sites-available
	apt-get -y install git
	phpenmod mcrypt
	apt-get -y install exim4-daemon-light mutt
	dpkg-reconfigure exim4-config
	read -p "A reboot is required.  Reboot Now?" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    reboot
	fi
fi

