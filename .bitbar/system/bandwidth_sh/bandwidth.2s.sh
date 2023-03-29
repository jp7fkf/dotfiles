#!/usr/bin/env bash

# <bitbar.title>Bandwidth</bitbar.title>
# <bitbar.version>v1.0.0</bitbar.version>
# <bitbar.author>jp7fkf</bitbar.author>
# <bitbar.author.github>jp7fkf</bitbar.author.github>
# <bitbar.desc>Displays TX and RX bitrate of your main ethernet interface in the status bar and hides other interfaces in the context menu.</bitbar.desc>
# <bitbar.dependencies>ifstat</bitbar.dependencies>

##################################################################
# The original implementation is follows(thanks Ant Cosentino):  #
# https://getbitbar.com/plugins/Network/bandwidth.1s.sh          #
#                                                                #
# The author edited a little for my own.                         #
# edited by jp7fkf(Y.Hashimoto)                                  #
##################################################################

export PATH="/usr/local/bin:${PATH}"
INTERFACES=$(ifconfig -lu)

echo "▼ $(ifstat -b -n -w -i en0 0.1 1 | tail -n 1 | awk '{print $1, "Kbps/", $2"Kbps";}') ▲"
echo "---"
for INTERFACE in ${INTERFACES}; do
  if [[ ${INTERFACE} != "en0" ]]; then
    echo "${INTERFACE}: ▼ $(ifstat -b -n -w -i "${INTERFACE}" 0.1 1 | tail -n 1 | awk '{print $1, "Kbps/", $2"Kbps";}') ▲"
  fi
done
