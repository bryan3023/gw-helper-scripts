#!/bin/sh

if [[ $# -eq 0 ]] ; then
  echo "This script takes a specified activity from a specified lesson and copies its"
  echo "contents into a folder with today's date under the in-class folder."
  echo
  echo "Optionally, you can pass \033[33m--code\033[0m to open the project in VS Code."
  echo
  echo "  Usage: \033[33m./cp_ex.sh <lesson number> <activity number> [--code]\033[0m"
  echo "   E.g.: \033[33m./cp_ex.sh 09 01 --code\033[0m"
  echo
  echo "Assumes this script is in a directory immediately under the root of your GW work."
  echo
  echo "  E.g., \033[33m~/gw-fullstack/scripts\033[0m"

  exit 1
fi

if [[ $# -lt 2 ]] ; then
  echo "\033[1mNot enough parameters!\033[0m"
  exit 1
fi

script_path=$0
script_dir_name=$(basename $(dirname $0))
lesson_number=$1
activity_numer=$2

caller_pwd=$PWD

echo $script_dir_name
function getScriptDir() {
  local x=2
}

function to_abs_path {
    local target="$1"

    if [ "$target" == "." ]; then
        echo "$(pwd)"
    elif [ "$target" == ".." ]; then
        echo "$(dirname "$(pwd)")"
    else
        echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
    fi
}



today=$(date +"%m-%d")


pwd_dir=$PWD
#echo $pwd_dir
pushd $script_dir 1> /dev/null

gw_root_dir=$script_dir/..

#echo $script_root_dir

echo ${to_abs_path script_root_dir}

lesson_dir=$(ls -d $gw_root_dir/lessons/$1*)
activity_dir=$(ls -d $lesson_dir/01-Activities/$2*)

src_dir=$activity_dir
dest_dir=$gw_root_dir/in-class/${today}

echo $src_dir
echo $dest_dir

# [ ! -d $dest_dir ] && mkdir -p $dest_dir

# cp -R $src_dir $dest_dir

popd 1> /dev/null

if [[ $3 -eq "--code" ]] ; then
  code_dir=$(ls -d $dest_dir/$2*)
  code $code_dir
fi

