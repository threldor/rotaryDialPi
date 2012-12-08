#!/bin/bash
t1="/sys/bus/w1/devices/28-000003eb83e3/w1_slave"
t2="/sys/bus/w1/devices/28-000003c1bf9e/w1_slave"

function read_temp() {
  res=`cat "$1"` 
  echo $res | grep -s  "YES" >/dev/null
  if [[ $? -eq 0 ]] ; then
    t=`echo $res| head -1 | awk 'BEGIN{FS="="} { sub("..$", "", $3); print ($3/10) }'`
  else
    t="BAD"
  fi
  echo $t
}

if [ "$1" = "-i" ] ; then
  sensor=$t2
elif [ "$1" = "-o" ] ; then
  sensor=$t1
else
  sensor=$t2
fi

while true; do
  temperature=`read_temp "$sensor"`
  d=`date +%s`
  if [ $temperature != "BAD" ];then
    break
  fi
done

echo "$temperature" 
