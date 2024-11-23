#!/usr/bin/env bash

# <bitbar.title>IP Info</bitbar.title>
# <bitbar.version>v1.0.0</bitbar.version>
# <bitbar.author>jp7fkf</bitbar.author>
# <bitbar.author.github>jp7fkf</bitbar.author.github>
# <bitbar.desc>Displays ipinfos on menu bar</bitbar.desc>
PATH=/opt/homebrew/bin/:$PATH

hoge=`curl -s ipinfo.io`
echo $hoge | jq -r '.ip'
echo "---"
echo $hoge | yq -P .
