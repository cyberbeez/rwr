#!/bin/sh

counter = 0
netstat -nlp | grep SYN_RECV | while read -r line
do
    ((counter++))
done

echo "`date`: There were $counter incomplete TCP connections detected." >> /var/log/tcpmonitor.log