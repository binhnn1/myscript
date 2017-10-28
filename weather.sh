#!/bin/sh
# Using Wunderground Weather API to query weather for the next n hours
# Please help by registering on wunderground to get your own APIKEY
# If you don't, please don't harrash my KEY :|
# USAGE: weather.sh -z <ZIPCODE> -s <STATE> -t <TIME>


#Copyright © 2017 Binh "Edward" Nguyen <binh.ng.nguyen@gmail.com>
#this work is free. You can redistribute it and/or modify it under the
#terms of the Do What The Fuck You Want To Public License, Version 2,
#as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.


APIKEY=f02ea4877b098adc
URL=http://api.wunderground.com/api/${APIKEY}/hourly/q/

#default values
ZIP=06032
STATE=CT
TIME=3
help=no

while [ ! -z "$1" ]; do
    case "$1" in
        -z|--zip)
            shift
            export ZIP="$1"
            ;;
        -s|--state)
            shift
            export STATE="$1"
            ;;
        -t|--time)
            shift
            export TIME="$1"
            ;;
        -h|--help)
            help=yes
            ;;
    esac
    shift
done

if [ "$help" == "yes" ]; then

    echo "-----------------------------------------------------------"
    echo "Usage: $0 -z <ZIPCODE> -s <STATE> - t <TIME>"
    echo "    <ZIPCODE>: Your zipcode, e.g. 06032"
    echo "    <STATE>  : Your state, e.g. CT"
    echo "    <TIME>   : how many hours forward, e.g. 3"
    echo "    e.g. $0 -z 06032 -s CT -t 3"
    echo "You can modify the default value to run with no argument"
    echo "-----------------------------------------------------------"
    return 1
fi

URL=${URL}${STATE}/${ZIP}.json


JSON=$(curl -s $URL)

parse_data() {
    VALUE="$2" JSON="$1" python - <<END 
import json, os

json_data = os.environ['JSON']
data = json.loads(json_data)
data_hours = data['hourly_forecast']

for x in range(0, int(os.environ['VALUE'])):
    data_hour = data_hours[x]
    print data_hour['FCTTIME']['pretty'] + ": " + data_hour['temp']['english'] + "F"
END
}

parse_data "$JSON" "$TIME"
