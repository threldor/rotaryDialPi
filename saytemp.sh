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
function say() { 
  local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?tl=en&q=The temperature is $temperature2 degrees inside and $temperature1 degrees outside.";
}

while true; do
  temperature1=`read_temp "$t1"`
  temperature2=`read_temp "$t2"`
  d=`date +%s`
  if [ $temperature1 != "BAD" ];then
    if [ $temperature2 != "BAD" ];then
      break
    fi
  fi
done

echo "Outside: $temperature1     Inside: $temperature2" 
say
