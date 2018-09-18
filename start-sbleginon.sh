#!/bin/bash

docker run --name sbleginon \
	--hostname=sbleginon \
	-d -p 10.132.100.105:80:80 \
	-p 10.132.100.105:443:443 \
	-p 10.132.100.105:2222:22 \
	-v `pwd`/install:/root/install \
	-v `pwd`/html:/var/www/html \
	-v `pwd`/database:/var/lib/phpMyAdmin/upload \
	-t otherdata/centos-docker-lamp:5.6
