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

readonly MCU_1="skr-v-1.3"
readonly DEV_1="/dev/serial/by-id/usb-Klipper_lpc1768_0D50FF1502942EAF8D89515BC62000F5-if00"

readonly MCU_2="octopus-v-1.1"
readonly DEV_2="/dev/serial/by-id/usb-Klipper_XY_NONE-if00"

readonly MCU_3="spider-v-1.1"
readonly DEV_3="/dev/serial/by-id/usb-Klipper_ZZ_NONE-if00"

install_firmware ${MCU_1} ${DEV_1}
install_firmware ${MCU_2} ${DEV_2}
install_firmware ${MCU_3} ${DEV_3}
