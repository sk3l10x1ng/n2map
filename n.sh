#!/usr/bin/env bash

TARGETSFILE="$2"
PORTSFILE="$3"

if [ -z "$2" ]
  then
    TARGETSFILE="naabu_output_targets.txt"
fi
if [ -z "$3" ]
  then
    PORTSFILE="naabu_output_ports.txt"
fi


# truncate files
truncate -s 0 $TARGETSFILE
truncate -s 0 $PORTSFILE

while IFS=: read ip port; do
  echo $ip>>$TARGETSFILE
  echo $port>>$PORTSFILE
done

# sort output
sort -u -o $TARGETSFILE $TARGETSFILE
sort -u -o $PORTSFILE $PORTSFILE

# in ports replace newline with comma
ports=`cat $PORTSFILE | tr '\n' ','`

# Running nmap on found results.

echo "Running nmap service scan on found results."
echo "Executing nmap -iL $TARGETSFILE -p ${ports:0:-1} -A"

nmap -iL $TARGETSFILE -p ${ports:0:-1} -sC -sV -O -oA $1 -Pn  --stylesheet=/home/sk3l10x1ng/sh/ctf/nmapxsl.xsl

xsltproc $1.xml -o $1.html


