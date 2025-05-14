#!/bin/sh

for roothub_wakeup in /sys/bus/usb/devices/usb*/power/wakeup ; do
  echo 'enabled' > $roothub_wakeup
done
