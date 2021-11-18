#!/usr/bin/env bash

#
# build and flash mcu firmware
#

#
# note: "make flash" needs dfu-util
# note: skr/smoothie needs initial manual flash via sd-disk
#

#set -e

readonly this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly base_dir="$( cd "$this_dir/../.." && pwd)"

echo "### base_dir=$base_dir"
echo "### this_dir=$this_dir"

function install_firmware() {
    
    local name=$1
    local path=$2
    
    local config="${this_dir}/board-${name}.cfg"
    local output="${base_dir}/out-${name}/"    

    echo "### build firmware"
    make PYTHON=python3 KCONFIG_CONFIG=${config} OUT=${output} menuconfig all

    echo "### flash firmware"
    make PYTHON=python3 KCONFIG_CONFIG=${config} OUT=${output} flash FLASH_DEVICE=${path}

}

cd "$base_dir"

#
# https://github.com/bigtreetech/BIGTREETECH-OCTOPUS-V1.0/blob/master/Hardware/BIGTREETECH%20Octopus.pdf
#
readonly MCU_1="octopus-v-1.1"
readonly DEV_1="/dev/serial/by-id/usb-Klipper_XY_NONE-if00"

#
# https://github.com/FYSETC/FYSETC-SPIDER/blob/main/hardware/Spider%20V1.0C%20SCH.pdf
#
readonly MCU_2="spider-v-1.1"
readonly DEV_2="/dev/serial/by-id/usb-Klipper_ZZ_NONE-if00"

#
# https://github.com/bigtreetech/BIGTREETECH-SKR-V1.3/blob/master/BTT%20SKR%20V1.3/hardware/SKR-V1.3-SCH.pdf
#
readonly MCU_3="skr-v-1.3"
readonly DEV_3="/dev/serial/by-id/usb-Klipper_lpc1768_0D50FF1502942EAF8D89515BC62000F5-if00"

#
# ID 2341:0010 Arduino SA Mega 2560 (CDC ACM)
# https://3dprint.wiki/reprap/wanhao/duplicator6/major_components/motherboard
#
readonly MCU_4="wd6-v-1.5"
readonly DEV_4="/dev/serial/by-id/usb-Arduino__www.arduino.cc__Arduino_Mega_2560_55639313433351504171-if00"

#install_firmware ${MCU_1} ${DEV_1}
#install_firmware ${MCU_2} ${DEV_2}
#install_firmware ${MCU_3} ${DEV_3}
install_firmware ${MCU_4} ${DEV_4}
