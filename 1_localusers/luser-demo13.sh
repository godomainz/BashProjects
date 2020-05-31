#!/bin/bash

# This script shows the open network ports on a system.
# Use -4 as an argument to limit to tcpv4 ports.
netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

# sudo du -h /var | sort -h
# netstat -nutl | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}' | sort -n | uniq -c
# grep bash /etc/passwd | wc -l
# grep -c bash /etc/passwd
# cat /etc/passwd | sort -t ':' -k 3 -n
# cat /etc/passwd | sort -t ':' -k 3 -n -r
# cat /etc/passwd | sort -t ':' -k 3 -n -r | tail -3