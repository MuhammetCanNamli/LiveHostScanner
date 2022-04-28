#! /bin/bash

ip4=$(hostname -I) #assigning IP address to variable
netid1=$(echo $ip4 | cut -f1 -d.) #
netid2=$(echo $ip4 | cut -f2 -d.) # IP network id parts
netid3=$(echo $ip4 | cut -f3 -d.) #

touch hosts.txt
echo "" >> hosts.txt
echo "----------LIVE HOSTS----------">> hosts.txt

for i in {1..254}
do
    touch ping_list$i.txt
    mcomid=$i # IP host id
    ip1=$netid1'.'$netid2'.'$netid3'.'$mcomid
    echo $ip1

    ping -c 1 $ip1 > ping_list$i.txt

    awk '{if (NR==2) {print$4}}' ping_list$i.txt > query.txt
    query=$(cat "query.txt")

    if [[ "$query" != "Destination" ]]
    then
        echo ${query} >> hosts.txt
        echo "" >> hosts.txt
        echo "Live Host"
        echo ""
    else
        echo "Dead Host"
        echo ""
    fi

    rm -r ping_list$i.txt
    rm -r query.txt
done

cat hosts.txt
rm -r hosts.txt
