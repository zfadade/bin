#!/bin/bash

base_dir='/Library/WebServer/Documents/cmform'
LANGS="en_US fr_FR"
COPYRIGHT_HOLDER=EnfinWeb
PACKAGE_NAME=CMForm
MSGID_BUGS_ADDR=zfadade@yahoo.com

po_gen=true
mo_gen=true

USAGE="USAGE: $0 [-pm] [-l lang] directory\nProcesses translation files. \n -p Only update .po files\n -m Only update .mo files\n -l language Only process the given language (fr_FR or en_US)\n"

while getopts "pml:" opt
do
  case $opt in
    p)
     	printf "Only generate .po files\n"
		mo_gen=false
      	;;
    m)
      	printf "Only generate .mo files\n"
		po_gen=false
      	;;
    l)
		LANGS=$OPTARG
      	printf "Only generate $LANGS files\n"
      	;;
    ?) 
        printf "$USAGE"
  	    exit 0
        ;;
  esac
done
shift $(( OPTIND - 1 ));

if [[ $# -ne 1 ]]
then
	printf "Must provide the directory name\n"
	printf "$USAGE"
	exit 1
fi

base_dir=$1
start_dir="$base_dir/admin"

for lang in fr_FR
do
	po_dir=$base_dir/locale/$lang/LC_MESSAGES
	po_file=$po_dir/messages.po
	mo_file=$po_dir/messages.mo
    
    # Recursively find all .php files.  Exclude files under /vendor
    php_files=$(find $base_dir -not -path "$base_dir/vendor*" -name "*.php" -type f -print)
     #php_files=$start_dir/users.php
    printf "php files: $php_files"
	if [ "$po_gen" == true ]
	then
    	printf "\nUpdating $po_file\n"
		xgettext  \
			--copyright-holder="$COPYRIGHT_HOLDER" \
			--package-name="$PACKAGE_NAME" \
			--package-version="0.1" \
			--language="PHP" \
			--msgid-bugs-address="$MSGID_BUGS_ADDR" \
			--from-code="UTF-8" \
			--omit-header \
			--join-existing \
			--output=$po_file \
            --join-existing \
			$php_files

#            --files-from=$php_files
#$base_dir/*.php 

    	printf "Converting $(basename $po_file) to $(basename $mo_file)\n"
	fi

	if [ "$mo_gen" == true ]
	then
    	printf "\nConverting $po_file to $mo_file\n"
    	msgfmt --verbose --output-file=$mo_file $po_file
		# msgfmt --check --verbose --output-file=$mo_file $po_file
	fi

done
