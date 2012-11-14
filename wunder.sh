#! /bin/bash
# wunder.sh
curl --silent "http://api.wunderground.com/api/MYKEY/conditions/q/Estonia/Tallinn.json" | awk -F ':'  '
/city/ { sub(",", "", $2) && c=$2 }
/temp_c/ { sub(",", "", $2); printf("The current temperature in %s today is %s degrees", c, $2); exit}'