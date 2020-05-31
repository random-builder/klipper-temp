#!/usr/bin/env bash

set -e

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "### this_dir=$this_dir"

cd "$this_dir/../.."

pwd

make
