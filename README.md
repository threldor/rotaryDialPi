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
This is read with two DS18B20 sensors connected with 1-wire to GPIO 4 using a single 4.7k pullup resistor. Both sensors are powered and are not configured in parasite mode.