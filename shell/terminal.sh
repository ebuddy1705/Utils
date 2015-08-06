#! /bin/sh

echo "ciscoasa>"
read cmd
while [ "$cmd" != "exit" ]
do
	echo "ciscoasa> $cmd"
	echo "ciscoasa>"
	read cmd
done



