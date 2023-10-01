#!/usr/bin/env bash

#
# update klipper.bin on octopi
#

set -e

octo_pi="pi@octopi1"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "### this_dir=$this_dir"

echo "### service stop"
ssh $octo_pi "sudo service klipper stop"

echo "### build clean"
ssh $octo_pi "cd /home/pi/klipper; make distclean"

echo "### copy config.cfg"
scp "$this_dir/config.cfg"  "$octo_pi:/home/pi/klipper/.config"

# board mode = normal ::
# Bus 001 Device 007: ID 1d50:614e OpenMoko, Inc. 

# board mode = bootloader ::
# Bus 001 Device 005: ID 1d50:6015 OpenMoko, Inc. Smoothieboard

echo "### build reflash"
#FLASH_DEVICE="1d50:6015"
#FLASH_DEVICE="/dev/ttyACM0"
FLASH_DEVICE="/dev/serial/by-id/usb-Klipper_lpc1768_16100006262006AF566E6E58C32000F5-if00"
ssh $octo_pi "cd /home/pi/klipper; make flash FLASH_DEVICE=$FLASH_DEVICE"

echo "### service start"
ssh $octo_pi "sudo systemctl enable klipper"
ssh $octo_pi "sudo service klipper stop"
ssh $octo_pi "sudo rm -rf /tmp/klippy*.log*"
ssh $octo_pi "sudo service klipper start"
