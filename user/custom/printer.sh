#!/usr/bin/env bash

#
# update printer.cfg on octopi
#

set -e

octo_pi="pi@octopi1"
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "### this_dir=$this_dir"

echo "### copy printer.cfg"
scp "$this_dir/printer.cfg" $octo_pi:/home/pi/printer.cfg

echo "### service restart"
ssh $octo_pi "sudo service klipper stop"
ssh $octo_pi "sudo rm -rf /tmp/klippy*.log*"
ssh $octo_pi "sudo service klipper start"
