#!/bin/bash
if [[ "$1" == "" ]]; then
	echo "Please specifiy an version argument"
	exit
fi
docker build --build-arg branch=$1 -t pi-zero .
docker run --rm --entrypoint cat pi-zero /build/diode_go_client/diode_linux_amd64.zip > diode_linux_arm.zip
