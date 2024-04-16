#!/usr/bin/env bash

set -e

this_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
base_dir=$( cd $this_dir/../.. && pwd )

echo "### base_dir=$base_dir"
echo "### this_dir=$this_dir"

base_config=$base_dir/.config
this_config=$this_dir/config.cfg

cd $base_dir

rm -f $base_config
ln -s $this_config $base_config 

#
#
#

make distclean

make
