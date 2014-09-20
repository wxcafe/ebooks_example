#!/bin/bash

BOT_NAME=`grep TWITTER_USERNAME bots.rb | head -1 | awk '{x=$3; gsub("\"","",x); print x}'`
USER_NAME=`grep TEXT_MODEL_NAME bots.rb | head -1 | awk '{x=$3; gsub("\"","",x); print x}'`

sed -i "s/bot_name_replace/$BOT_NAME/" run.sh
sed -i "s/username_replace/$USER_NAME/" run.sh
