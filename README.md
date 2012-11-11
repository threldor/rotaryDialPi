# Raspberry Pi in a Rotary Dial Phone #
========================================
The first intention for this project was to put skype on the raspberry pi and use this as a skype voice call client. Considering how downloading the skypekit is no longer available this quickly changed.

Now this project will allow the user to dial a number on the phone and using the raspberry pi the phone will read back some information like
 * Time
 * Date
 * Temperature inside or outside(dual DS18B20 sensor)
 * A random compliment
 * Latest news headlines
 * weather for the day
 * anything else I can think of

 
## So what is inside and how does it work ##
At present there is the raspberry pi, the phone and two DS18B20 temperature sensors. 

### Temperature Sensors ###
These are two DS18B20 sensors connected with 1-wire to GPIO 4 using a single 4.7k pullup resistor to 3.3V. Both sensors are powered from 3.3V and are not configured in parasite mode.  
To get them working on the pi by loading them manually I used
~~~
    modprobe w1-gpio
    modprobe w1-therm
~~~
and to load them automatically add these lines to _/etc/modules_
~~~
    w1-gpio
    w1-therm
~~~
To read the sensor you just use this, where 28-00xxxxxxx is your device.
~~~
    cat /sys/bus/w1/devices/28-000035432/w1-slave
~~~

### Rotary Dial ###
This is a fairly basic device. I found a sweet library written by markfickett [here](https://github.com/markfickett/Rotary-Dial) for the arduino. I used it to confirm mine operated the same and quickly realised that my phone goes 0,1,2...9 not 1,2,3...9,0. So this is a trap for young players.  
Connection is as follows;  
The common goes to ground, both contacts are connected to 3.3V through some pull up resistors. The contacts are then connected to your input pins.

### Handset ###
This has a speaker at the ear end and this is connected to the 3.5mm audio jack on the raspberry pi.

### Speech ###
I decided, after reading  and testing [this](http://elinux.org/RPi_Text_to_Speech_(Speech_Synthesis)) that I should use the Google Text to speech and espeak as a backup for no internet connection. There is a good guide there how to get this working. I still have some troubles with poping and cracking when the speaking starts and stops but this will be investigated soon.

## Other ideas and changes ##
 * Use a wifi dongle as then the phone will only need power connection.
 * Use a power over ethernet breakout for the same reason as above.
 * Get skype or another free commonly used internet calling program working.
 * Use a larger phone with the ringer for an alarm clock
 * Setup the usb microphone so that a message can be recorded and played back later, or sent to someone as mp3 or text with speech to text decoding.
 * Add a ringer.