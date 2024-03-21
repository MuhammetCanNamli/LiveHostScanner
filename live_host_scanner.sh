#! /bin/bash

ip4=$(hostname -I | awk '{print $1}') # Get the primary IP address
IFS='.' read -r netid1 netid2 netid3 _ <<< "$ip4"

echo "" >> hosts.txt
echo "----------LIVE HOSTS----------">> hosts.txt

for i in {1..254}; do # Loop through the IP range
    (
        ip="$netid1.$netid2.$netid3.$i"
        if ping -c 1 -W 1 $ip &> /dev/null; then # Ping with a timeout of 1 second
            echo "$ip is live" >> hosts.txt
        fi
    ) &
done
wait # Wait for all background processes to finish

cat hosts.txt
rm -r hosts.txt
