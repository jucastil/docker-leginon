#!/bin/bash

EXPECTED_ARGS=3
if [[ $# -ne $EXPECTED_ARGS ]]; then 
	echo "";
	echo "    USAGE: ./start-sbleginon.sh NAME HOSTNANE IP";
	echo "";
	exit 0
fi

NAME=$1
HOSTNAME=$2
IP=$3

docker run --name $NAME \
	--hostname=$HOSTNAME \
	-d -p $IP:80:80 \
	-p $IP:443:443 \
	-p $IP:2222:22 \
	-v `pwd`/extra:/extra \
	-v `pwd`/html:/var/www/html \
	-v `pwd`/database:/var/lib/phpMyAdmin/upload \
	-t otherdata/centos-docker-lamp:5.6
