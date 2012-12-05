#! /bin/bash
# weather.sh

if [ "$1" = "-now" ] ; then
  curl --silent "http://weather.yahooapis.com/forecastrss?w=845743&u=c" | awk -F '- '  '
  /<b>Current Conditions:/ { getline; gsub("C<.*", "", $1); printf("The weather is currently %s\n", $1); exit }'
elif [ "$1" = "-today" ] ; then
  curl --silent "http://weather.yahooapis.com/forecastrss?w=845743&u=c" | awk -F '- '  '
  /<b>Forecast/ { getline; gsub("<.*", "", $2); printf("The weather today is %s\n", $2); exit }'
elif [ "$1" = "-tomorrow" ] ; then
  curl --silent "http://weather.yahooapis.com/forecastrss?w=845743&u=c" | awk -F '- '  '
  /<b>Forecast/ { getline; getline; gsub("<.*", "", $2); printf("The weather tomorrow is %s\n", $2); exit }'
else
  curl --silent "http://weather.yahooapis.com/forecastrss?w=845743&u=c" | awk -F '- '  '
  /<title>/ { gsub(",.*", "", $2) && l=$2 }
  /<b>Current Conditions:/ { getline; gsub("<.*", "", $1) && m=$1 }
  /<b>Forecast/ { getline; getline; gsub("<.*", "", $2); printf("The weather for %s:\nCurrently it is %s\nTomorrow is %s\n", l, m, $2); exit }'
fi

