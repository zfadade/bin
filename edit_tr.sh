#!/bin/bash

USAGE="USAGE: $0 [-ef] directory\nEdits translation .po files. \nUse -f or -e to edit only French or English files\n"

base_dir='/Library/WebServer/Documents/cmform'
lang="??_??"

while getopts "ef" opt
do
  case $opt in
    e)
		lang=en_US
      	;;
    f)
        lang=fr_FR
      	;;
    ?)  printf "$USAGE"
        exit 2
        ;;
  esac
done
# shift $(( OPTIND - 1 ));

if [[ $# -ne 1 ]]
then
	printf "Must provide the directory name\n"
	printf "$USAGE"
	exit 1
fi

base_dir=$1
vim $base_dir/locale/$lang/LC_MESSAGES/*.po
