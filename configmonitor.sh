#!/bin/sh

files=("/etc/sysctl.conf" "/etc/security/limits.conf" "/etc/syslog.conf" "/etc/network/interfaces" "/etc/resolv.conf" "/etc/passwd" "/etc/group" "/etc/shadow" "/etc/fstab" "/etc/mtab")
backup="./backup"

while :
do
    for file in $files
    do
        if [ ! -f $backup$file ]; then
            cp $file $backup$file
        fi
    done

    for file in $files
    do
        diff $file $backup$file >> ./differences.txt
    done
    
    sleep 5m
done