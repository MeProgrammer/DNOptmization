#!/bin/bash

echo -n "please enter the router ip:"
read -e device_address
./finding_ip.sh $device_address>access.txt
#the place for the network_addresses array
echo -n "enter a valid ip to search for:";
read -e ip;
IFS='
'
var=32;

for wildcard in $(cat netmask);
do
	wildcard[$var]=$(echo $wildcard |cut -d ' ' -f2)
	let var--;	
done

case $(ipcalc -m $ip | cut -d = -f2) in
255.0.0.0) n=9;;
255.255.0.0) n=17;;
255.255.255.0) n=25;;
esac


###############adding the ips to an array############

addresses=(); 

for((k=$n;k<=32;k++));
do
	addresses[$k]=$(ipcalc -n $ip/$k |cut -d = -f2);
done


##############comparison & printing ################
for line in $(cat access.txt);
do
	if [[ $line =~ ^ipv4 ]]
	then
		access_list_name=$line;
	else
		[[ $line =~ permit ]]&& permit=$(echo $line |tr ' ' _);
		for ((i=$n;i<=31;i++));
		do
			if [[ $line =~ ${addresses[$i]} ]] && [[ $line =~ ${wildcard[$i]} ]];
			then
				echo $access_list_name | tr _ ' ';
				echo $permit | tr _ ' ';
				echo "################################################";
			fi
		done
	fi
done
