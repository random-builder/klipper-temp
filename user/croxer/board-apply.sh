#!/usr/bin/env bash

#
# update firmware on remote host
#

set -e

print3d_unit="1"
print3d_user="print3d"
octoprint_host="octo1"
octoprint_port="500$print3d_unit"
octoprint_url="http://$octoprint_host:$octoprint_port"
ssh_root_url="root@$octoprint_host"
ssh_user_url="$print3d_user@$octoprint_host"
print3d_klip_dir="$print3d_unit/klip"
print3d_data_dir="$print3d_klip_dir/data"
print3d_logs_file="$print3d_data_dir/service.log"
print3d_repo_dir="$print3d_klip_dir/repo"
print3d_this_dir="$print3d_repo_dir/user/croxer"
print3d_service="klipper@$print3d_unit.service"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

klipper_service() {
    local command="$1"
    echo "### service $command : $print3d_service"
    ssh $ssh_root_url "systemctl $command $print3d_service"
}

octoprint_connection() {
    local command="$1"
    echo "### octoprint $command : $octoprint_url"
    curl \
    --silent \
    --request POST \
    --header "X-Api-Key: AD1D0068CFB74AC9BC447D23B8FC7656" \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --data '{ "command":"'$command'" }' \
    $octoprint_url/api/connection
}

echo "### that_repo=$print3d_repo_dir"


echo "### repo reset"
ssh $ssh_user_url "cd $print3d_repo_dir; git reset --hard"

echo "### repo update"
ssh $ssh_user_url "cd $print3d_repo_dir; git pull"

klipper_service enable

echo "### board copy"
scp $this_dir/board*.*  $ssh_user_url:$print3d_this_dir

octoprint_connection disconnect
klipper_service stop
ssh $ssh_user_url "rm -f $print3d_logs_file"

echo "### board setup"
ssh $ssh_user_url "cd $print3d_this_dir; MENU_WORD='' ./board.sh"

klipper_service start
sleep 3
octoprint_connection connect

echo "### operation complete"
