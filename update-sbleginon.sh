#!/bin/bash
####---------------------------------
# more info about how to update container hw demands
# https://github.com/wsargent/docker-cheat-sheet
# all cpus = 1024
# memory = 300 M
####---------------------------------

docker update \
	--cpu-shares 512 -m 300M sbleginon
