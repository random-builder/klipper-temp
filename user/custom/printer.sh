#!/usr/bin/env bash

#
# update printer.cfg on octopi
#

set -e

make_host="make_print@make1"
klipper_unit="make_klipper-wanhao_d6.service"
klipper_data="/home/make_print/wanhao_d6/klip/data"
klipper_repo="/home/make_print/wanhao_d6/klip/repo"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#echo "### this_dir=$this_dir"

echo "### copy printer.cfg"
scp "$this_dir/printer.cfg" $make_host:$klipper_repo/user/custom/printer.cfg

echo "### service unit restart"
ssh $make_host "sudo systemctl stop   $klipper_unit"
ssh $make_host "rm -rf $klipper_data/service.log"
ssh $make_host "sudo systemctl start  $klipper_unit"
