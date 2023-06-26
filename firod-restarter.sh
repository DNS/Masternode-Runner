#!/bin/sh

# updated: 30/12/2022

(while true; do
    if ! ps -e | grep firod; then
        /root/firo/bin/firod -daemon -dbcache=50 -datadir=/root/.firo
    fi
	sleep 180
done) &

