#!/bin/bash

INTERVAL=0.1

TIMER=`date +%s`
LEN=10M
OFF=`expr $TIMER + 300`

nohup iperf -s -f m -i $INTERVAL -T 64 > "$PWD/results_server_`date +%b_%d_%Y_%H_%M_%S`.txt" &

while [[ `date +%s` -lt $OFF  ]]; do
  :
done

pid=`ps ax | grep "iperf -s" | grep -v grep | awk '{printf $1}'`
kill -9 $pid
