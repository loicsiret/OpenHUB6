#!/bin/sh

# H - Home Assistant Notification
## Variables for MQTT to Home Assistant
ha_topicmsg="dsc/Get/Partition/Message"
haip=`uci get alarm-notify.api.ha_ip`
haport=`uci get alarm-notify.api.ha_port`
hauser=`uci get alarm-notify.api.ha_user`
hapass=`uci get alarm-notify.api.ha_pass`

# if the Home Assistant topic is NOT blank
# publish specific TOPIC messages
if [[ ! -z "$4" ]]
then
    mosquitto_pub -h $haip -p $haport -u $hauser -P $hapass -t $4 -m "$5" -r
fi

# publish Event Message with MQTT
mosquitto_pub -h $haip -p $haport -u $hauser -P $hapass -t $ha_topicmsg -m "$3" -r
