#!/bin/bash

# Count number of failed logins by IP address.
# If there are any IPs with over LIMIT failures, display the count, IP, and location.
LIMIT='2'
LOG_FILE="${1}"

# Make sure a sile was supplied as an argument
if [[ ! -e "${LOG_FILE}" ]]
then
    echo "Cannot open log file: ${LOG_FILE}" >&2
    exit 1
fi

# Display the CSV header.
echo 'Count,IP,Location'

# Loop through the list of failed attempts and corresponding IP addresses.
grep Failed syslog-sample | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
    # IF the number of failed attempts is greater than the limit, display count, IP and location.
    if [[ "${COUNT}" -gt "${LIMIT}" ]]
    then
        LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $(NF)}')
        echo "${COUNT},${IP},${LOCATION}"
    fi
done
exit 0;