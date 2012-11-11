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
readyPin=0
pulsePin=1
handsetPin=2

# setup:
#       Initialise the GPIO
#######################################################################

setup()
{
  echo Setup
  for i in $readyPin $pulsePin $handsetPin ; do gpio mode $i in ; done
}

# waitHandset:
#       Wait for the handset to be lifted. Because we have the GPIO
#       pin pulled high, we wait for it to go low.
#######################################################################

waitHandset ()
{
  echo -n "Waiting for handset ... "
  while [ `gpio read $handsetPin` = 1 ]; do
    sleep 0.2
  done
  echo "Handset lifted"
}

# waitReady:
#       Wait for the ready pin to change state indicating the phone is 
#       being dialed. We also need to monitor the handset to see if
#       this is hung up. 
#######################################################################

waitReady ()
{
  echo -n "Waiting for ready ... "
  while [ `gpio read $readyPin` = 1 ]; do
    if [ `gpio read $handsetPin` = 1 ] ; then
      # handset hung up
      break
    fi
    sleep 0.1
  done
  echo "Handset lifted"
}

#######################################################################
# The main program
#       Setup pins then monitor the handsetPin and go from there.
#######################################################################

setup
while true; do
  waitHandset
done