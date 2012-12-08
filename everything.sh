#!/bin/bash

# rotaryDial:
#       Read a rotary dial phone on the pi
#
#       Wait for the handset to be lifted then monitor the ready pin
#       should this change we need then count the number of pulses 
#       that occur before the ready pin returns to its original state.
#       If the handset is hung up we abort and continue to monitor it.
#
#       James Connor, November 2012

# input pin numbers
# GPIO 24
readyPin=5
# GPIO 23
pulsePin=4
# GPIO 26
handsetPin=6

# variables
DEBOUNCE=15
WAITING=0
LISTENNOPULSE=1
LISTENPULSE=2

# more variables
state=0
currentTime=$(date +%s%N)
lastStateChangeMillis=$(($currentTime/1000000))

# setup:
#       Initialise the GPIO
#######################################################################

setup()
{
  echo Setup
  for i in $readyPin $pulsePin $handsetPin ; do gpio mode $i in ; done
}

# say:
#       say the passed arguments
#######################################################################

say()
{ 
  local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?tl=en&q=$*"; 
}

# readAll:
#       Read all input pins and display
#######################################################################

readAll()
{
  echo "reading..."
  for i in $readyPin $pulsePin $handsetPin ; do gpio read $i ; done
}

# waitHandset:
#       Wait for the handset to be lifted. Because we have the GPIO
#       pin pulled high, we wait for it to go low.
#######################################################################

waitHandset ()
{
  echo -n "Waiting for handset ... "
  while [ `gpio read $handsetPin` = 0 ]; do
    sleep 0.1
  done
  echo "Handset lifted"
}

# changeState:
#       change state to the given state, includes debounce.
#       0=waiting, 1=listen for no pulse, 2=listen pulse.
#######################################################################

changeState ()
{
  currentTime=$(date +%s%N)
  currentMillis=$(($currentTime/1000000))
  # perhaps need to add in wrap around of millis
  if [ $(($currentMillis-$lastStateChangeMillis)) -gt $DEBOUNCE ] ; then
    state=$1
    lastStateChangeMillis=$currentMillis
    return 0
  else
    return 1
  fi
}

# completeDial:
#       Wait for the handset to be lifted. Because we have the GPIO
#       pin pulled high, we wait for it to go low.
#######################################################################

completeDial ()
{
  if changeState $WAITING ; then
    echo $(($number-1))
    if [ $(($number-1)) = 1 ] ; then
      words=`/home/pi/rotaryDialPi/weather.sh -now 2>&1`
      echo $words
      say $words
    elif [ $(($number-1)) = 2 ] ; then
      words=`/home/pi/rotaryDialPi/weather.sh -today 2>&1`
      echo $words
      say $words
    elif [ $(($number-1)) = 3 ] ; then
      words=`/home/pi/rotaryDialPi/weather.sh -tomorrow 2>&1`
      echo $words
      say $words
    elif [ $(($number-1)) = 4 ] ; then
      temp=`/home/pi/rotaryDialPi/readTemperature.sh -i 2>&1`
      echo "It is currently $temp degrees inside"
      say "It is currently $temp degrees inside"
    elif [ $(($number-1)) = 5 ] ; then
      temp=`/home/pi/rotaryDialPi/readTemperature.sh -o 2>&1`
      echo "It is currently $temp degrees outside"
      say "It is currently $temp degrees outside"
    else
      compliment=`sort -R /home/pi/rotaryDialPi/compliments.txt | head -n 1`
      echo $compliment
      say $compliment
    fi
  fi
}

#######################################################################
# The main program
#       Setup pins then monitor the handsetPin and go from there.
#######################################################################

setup
readAll

while true; do
  waitHandset
  # someone picked up the handset so lets start watching those pins
  while [ `gpio read $handsetPin` = 1 ] ; do
    case $state in
      # WAITING
      0 )
        if [ `gpio read $readyPin` = 0 ] && changeState $LISTENNOPULSE ; then
          number=0
        fi
      ;;
      # LISTENNOPULSE
      1 )
        if [ `gpio read $readyPin` = 1 ] ; then
          completeDial
        elif [ `gpio read $pulsePin` = 1 ] ; then
          changeState $LISTENPULSE 
        fi
      ;;
      # LISTENPULSE
      2 )
        if [ `gpio read $readyPin` = 1 ] ; then
          completeDial
        elif [ `gpio read $pulsePin` = 0 ] && changeState $LISTENNOPULSE  ; then
          number=$(($number+1))
        fi
      ;;
    esac
  done
done
