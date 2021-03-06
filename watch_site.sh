#!/bin/sh

# Author: Brian Lam
#
# Repeatedly download a specified webpage and check if it has been updated
# with a specific regex. If regex matches, send email notification to X address.
#
# Use cases:
# -> Check for certain web vulns on a webpage
# -> Modify script to use a file with multiple lines of regex (improved search)
# -> If web vuln present, modify script to probe the vuln on webpage + return result

# check every hour
check=3600

# assign args to values, else incorrect usage
if [ $# = 3 ]
then
	url=$1
	regexp=$2
	email_address=$3
else
	echo "Usage: $0 <url> <regex> <email@address.com>"
	exit 1
fi

# repeat webpage download until regex match, dump output
while true
do  
	if wget -O- -q "$url"|egrep "$regexp" >/dev/null	
	then
		echo "Generated by $0" | mail -s "$url now matches $regexp" $email_address
		exit 0
	fi
	sleep $check
done

