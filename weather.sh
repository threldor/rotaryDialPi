#! /bin/bash
# weather.sh
curl --silent "http://weather.yahooapis.com/forecastrss?w=845743&u=c" | awk -F '- '  '
/<title>/ { gsub(",.*", "", $2) && l=$2 }
/<b>Current Conditions:/ { getline; gsub("<.*", "", $1) && m=$1 }
/<b>Forecast/ { getline; gsub("<.*", "", $2); printf("The weather for %s:\nToday is %s\nTomorrow is %s\n", l, m, $2); exit }'