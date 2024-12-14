#!/usr/bin/env bash

inotifywait -r -m /opt/drop_files/pcaps/ -e create -e moved_to |
    	while read -r directory action file
	do
            echo "Processing: '$file'" >> /opt/drop_files/scripts/logs/monitor_files.log
            /bin/bash /opt/drop_files/scripts/parse_pcap.sh "$file" "/opt/drop_files/pcaps/"
    	done
