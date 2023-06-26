#!/bin/sh

# check every 1 day (86400 seconds)

(while true; do
    /root/firod-updater.ps1
    date '+%d/%m/%Y %H:%M:%S' >> /root/FIRO-UPDATER.LOG
    sleep 86400
done) &

