#!/bin/bash
t1="/sys/bus/w1/devices/28-000003eb83e3/w1_slave"
t2="/sys/bus/w1/devices/28-000003c1bf9e/w1_slave"

function read_temp() {
  res=`cat "$1"` 
  echo $res | grep -s  "YES" >/dev/null
  if [[ $? -eq 0 ]] ; then
    t=`echo $res| head -1 | awk 'BEGIN{FS="="} { print ($3/1000) }'`
  else
    t="BAD"
  fi
  echo $t
}

while true; do
  temperature=`read_temp "$t1"`
  d=`date +%s`
  if [ $temperature != "BAD" ];then
    break
  fi
done

echo "$temperature" 
