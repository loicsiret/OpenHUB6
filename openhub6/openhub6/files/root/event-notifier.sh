#!/bin/sh

# Arguments
# 1:cmd 2:cmddata 3:event 4:haTopic 5:haMsg

## get the Notifier Event label based on the command
notifylabel=""
notifylabel=`uci get alarm-event.cmd.$1`

# System Log
case $notifylabel in
  *L*)
    logger -t $0 "1=$1 2=$2 3=$3 4=$4 5=$5 Notify=$notifylabel"
;; esac

# T - Telegram Notification - World42Alarm bot
case $notifylabel in
  *T*)
    botToken=`uci get alarm-notify.api.tel_api_token`
    chatID=`uci get alarm-notify.api.tel_chatid`
    URL="https://api.telegram.org/bot$botToken/sendMessage"
    curl -X POST --silent --output /dev/null $URL -d chat_id=$chatID -d text="$3" &
;; esac

# P - Pushover Notification
case $notifylabel in
  *P*)
    curl -s \
      --form-string "token=`uci get security-pushover.api.api_key`" \
      --form-string "user=`uci get security-pushover.api.user_key`" \
      --form-string "message=$3" \
    https://api.pushover.net/1/messages.json >/dev/null &
;; esac

# H - Home Assistant Notification
case $notifylabel in
  *H*)
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
    mosquitto_pub -h $haip -p $haport -u $hauser -P $hapass -t $ha_topicmsg -m "$3" -r &
;; esac

