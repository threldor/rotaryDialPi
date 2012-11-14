#! /bin/bash
# wunder.sh
key=$(cat wunderkey)
curl --silent "http://api.wunderground.com/api/$key/conditions/q/Estonia/Tallinn.json" | awk -F ':'  '
/city/ { sub(",", "", $2) && c=$2 }
/temp_c/ { sub(",", "", $2); printf("The current temperature in %s today is %s degrees\n", c, $2); exit}'
