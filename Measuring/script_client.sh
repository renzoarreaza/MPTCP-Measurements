#!/bin/bash

#Parameters
INTERVAL=0.2
LEN=20M
HOST=80.114.175.209
PARALLEL=1
REP=1
INTERFACE4G="enp0s20u4"
SWITCH1=4 
SWITCH2=8 

COUNT=1

while [[ "$COUNT" -le "$REP" ]]
do 

  #TEST 1 - FULL-MPTCP

  #Time References
  INITIAL=`date +%s`
  OFF=`expr $INITIAL + $SWITCH1`
  ON=`expr $INITIAL + $SWITCH2`

  #IPERF command
  iperf -f m -c $HOST -i $INTERVAL -n $LEN -P $PARALLEL -T 64 2>&1 > $PWD/result_client_fullmptcp_$DATAI.txt &

  #Wait 4s
  while [[ `date +%s` -lt $OFF ]]
  do
    :
  done

  #Switch off wifi (eth0 in mininet)
  nmcli radio wifi off
  #ip link set down h1-eth0

  #Wait 8 s
  while [[ `date +%s` -lt $ON ]]
  do
    :
  done

  #Switch on wifi (eth0 in mininet)
  nmcli radio wifi on
  #ip link set up h1-eth0

  sleep 90
 

  #TEST 2 - BACKUP-MPTCP

  ip link set dev $INTERFACE4G multipath backup
  #ip link set dev h1-eth1 multipath backup

  #Time References
  INITIAL=`date +%s`
  OFF=`expr $INITIAL + $SWITCH1`
  ON=`expr $INITIAL + $SWITCH2`

  #IPERF command
  iperf -f m -c $HOST -i $INTERVAL -n $LEN -P $PARALLEL -T 64 2>&1 > $PWD/result_client_backupmptcp_$DATAI.txt &

  #Wait 4s
  while [[ `date +%s` -lt $OFF ]]
  do
    :
  done

  #Switch off wifi (eth0 in mininet)
  nmcli radio wifi off
  #ip link set down h1-eth0

  #Wait 8s
  while [[ `date +%s` -lt $ON ]]
  do
    :
  done

  #Switch on wifi (eth0 in mininet)
  nmcli radio wifi on
  #ip link set up h1-eth0

  sleep 90
 

  ip link set dev $INTERFACE4G multipath on
  #ip link set dev h1-eth1 multipath on


  #TEST 3 - TCP

  sysctl -w net.mptcp.mptcp_enabled=0
  sysctl -w net.ipv4.tcp_congestion_control=cubic

  #Time References
  INITIAL=`date +%s`
  OFF=`expr $INITIAL + $SWITCH1`
  ON=`expr $INITIAL + $SWITCH2`

  #IPERF command
  iperf -f m -c $HOST -i $INTERVAL -n $LEN -P $PARALLEL -T 64 2>&1 > $PWD/result_client_tcp_wifi_$DATAI.txt &

  #Wait 4s
  while [[ `date +%s` -lt $OFF ]]
  do
    :
  done

  #Switch off wifi (eth0 in mininet)
  nmcli radio wifi off
  #ip link set down h1-eth0


  #Wait 8s
  while [[ `date +%s` -lt $ON ]]
  do
    :
  done

  #Switch on wifi (eth0 in mininet)
  nmcli radio wifi on
  #main link will recover the connection
  #ip link set up h1-eth0

  sleep 90
 
  sysctl -w net.mptcp.mptcp_enabled=1
  sysctl -w net.ipv4.tcp_congestion_control=olia
  
  COUNT=`expr $COUNT + 1`

done
