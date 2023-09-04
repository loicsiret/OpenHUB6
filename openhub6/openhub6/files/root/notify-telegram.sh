#!/bin/sh

# T - Telegram Notification
botToken=`uci get alarm-notify.api.tel_api_token`
chatID=`uci get alarm-notify.api.tel_chatid`
URL="https://api.telegram.org/bot$botToken/sendMessage"

curl -X POST --silent --output /dev/null $URL -d chat_id=$chatID -d text="$1"
