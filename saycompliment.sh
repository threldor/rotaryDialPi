#!/bin/bash
compliment=`sort -R compliments.txt | head -n 1`
function say() { 
  local IFS=+;/usr/bin/mplayer -ao alsa -really-quiet -noconsolecontrols "http://translate.google.com/translate_tts?tl=en&q=$compliment"; 
}
say
