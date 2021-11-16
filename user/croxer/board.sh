#!/usr/bin/env bash

#
# build and flash mcu firmware
#

#
# note: "make flash" needs dfu-util
# note: skr/smoothie needs initial manual flash via sd-disk
#

set -e

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
    make KCONFIG_CONFIG=${config} OUT=${output} menuconfig all

    echo "### flash firmware"
    make KCONFIG_CONFIG=${config} OUT=${output} flash FLASH_DEVICE=${path}

}

cd "$base_dir"

readonly MCU_1="skr-v-1.3"
readonly DEV_1="/dev/serial/by-id/usb-Klipper_lpc1768_0D50FF1502942EAF8D89515BC62000F5-if00"

install_firmware ${MCU_1} ${DEV_1}
