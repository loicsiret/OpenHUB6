#!/bin/sh

# P - Pushover Notification
curl -s \
    --form-string "token=`uci get security-pushover.api.api_key`" \
    --form-string "user=`uci get security-pushover.api.user_key`" \
    --form-string "message=$1" \
https://api.pushover.net/1/messages.json >/dev/null
