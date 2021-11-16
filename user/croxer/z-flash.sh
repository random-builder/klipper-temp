#!/usr/bin/env bash

set -e

octo_pi="pi@octopi1"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "### this_dir=$this_dir"

echo "### config reset"
ssh $octo_pi "cd /home/pi/klipper; make distclean"

echo "### copy config.cfg"
scp "$this_dir/config.cfg"  $octo_pi:/home/pi/klipper/.config

echo "### firmware rebuild"
ssh $octo_pi "sudo service klipper stop"
ssh $octo_pi "cd /home/pi/klipper; make flash FLASH_DEVICE=/dev/ttyACM0"

echo "### service restart"
ssh $octo_pi "sudo systemctl enable klipper"
ssh $octo_pi "sudo service klipper stop"
ssh $octo_pi "sudo rm -rf /tmp/klippy*.log*"
ssh $octo_pi "sudo service klipper start"
