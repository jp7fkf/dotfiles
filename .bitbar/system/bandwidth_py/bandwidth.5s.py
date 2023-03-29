#!/usr/bin/env -S PATH="${HOME}/.pyenv/shims:${PATH}" PYTHONIOENCODING=UTF-8 python3
# -*- coding: utf-8 -*-

# <bitbar.title>Bandwidth.py</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>jp7fkf</bitbar.author>
# <bitbar.author.github>jp7fkf</bitbar.author.github>
# <bitbar.desc>Displays upload and download speeds</bitbar.desc>
# <bitbar.dependencies>python3, psutil</bitbar.dependencies>

"""
    An implementation in python of the Bandwith Bitbar Plugin
    Should work on Linux too with Argos or other status bar (Polybar for example)
    https://getbitbar.com/plugins/Network/bandwidth.1s.sh

    Unlike the shell status bar, here he result displayed in the bar will the total of all interfaces

    This is based by following implementation(thanks ChTBoner):
    https://raw.githubusercontent.com/matryer/bitbar-plugins/master/Network/bandwidth.1s.py

    The author edited a little for my own.
    edited by jp7fkf(Y.Hashimoto)
"""

import psutil
from time import sleep

SLEEP = 3

def human_bytes(n):
    """
        convert bytes to human readable format
        'borrowed' from https://github.com/giampaolo/psutil/blob/master/scripts/ifconfig.py
    """

    symbols = ('k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
    prefix = {}
    for i, s in enumerate(symbols):
        prefix[s] = 1 << (i + 1) * 10

    for symbol in reversed(symbols):
        if n >= prefix[symbol]:
            value = n / prefix[symbol]
            return '{:5.1f}{}bps'.format(round(value, 2), symbol)
    return "{:5.1f}bps".format(round(n, 2))


def print_stats(upload, download):
    """
    pretty prints the results
    upload and download values are multiplied by 2 to compensate 0.5 second sleep
    """
    return "▼ {}/{} ▲".format(human_bytes(download / SLEEP * 8), human_bytes(upload / SLEEP * 8))


def main():
    # create dict to store results for every interface
    results = {}

    # set original data and store it in dict
    results.update(
        {'total': {
            'up': psutil.net_io_counters(pernic=False).bytes_sent,
            'down': psutil.net_io_counters(pernic=False).bytes_recv}
        })

    # loops through all interfaces to store upload and download data
    for interface in psutil.net_io_counters(pernic=True):
        results.update(
            {interface: {
                'up': psutil.net_io_counters(pernic=True)[interface].bytes_sent,
                'down': psutil.net_io_counters(pernic=True)[interface].bytes_recv}
            })

    sleep(SLEEP)

    # after sleeping, updates the data to be the difference between the two iterations
    results.update(
        {'total': {
            'up': psutil.net_io_counters(pernic=False).bytes_sent - results["total"]["up"],
            'down': psutil.net_io_counters(pernic=False).bytes_recv - results["total"]["down"]}
        })

    # iterates over interfaces to update data
    for interface in results:
        if interface != 'total':
            results.update({
                interface: {
                    'up': psutil.net_io_counters(pernic=True)[interface].bytes_sent - results[interface]["up"],
                    'down': psutil.net_io_counters(pernic=True)[interface].bytes_recv - results[interface]["down"]}
            })

    # print the result to the bar
    print(print_stats(results["total"]["up"], results["total"]["down"]))

    print('---')
    # print in dropdown
    for interface in results:
        if interface != 'total':
            print("{}: {}".format(interface, print_stats(results[interface]["up"], results[interface]["down"])))


if __name__ == '__main__':
    main()
