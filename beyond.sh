#!/bin/bash 
 COUNTER=0
while [  $COUNTER -lt 5 ]; do
kill $(pgrep telegram-cli)
./launch.sh
sleep 1
#let COUNTER=COUNTER+1 
done
