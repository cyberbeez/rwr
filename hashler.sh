#!/bin/bash
#This script will run a md5 hash backup and check job.
#To use this script, change these variables:
#file="/etc/passwd"

### CHANGE ME: ###
file="/d/f"
while:
do
md5sum $file > $file+"_hashler.md5"
sleep 300 #5mins
md5sum -c $file+"_hasler.md5"
done
