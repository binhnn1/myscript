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
    esac
    shift
done

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
