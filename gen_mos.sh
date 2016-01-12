#!/bin/bash

LANGS="en_US fr_FR"
po_gen=true
mo_gen=true

while getopts "pml:" opt
do
  case $opt in
    p)
     	echo "Only generate .po files"
		mo_gen=false
      	;;
    m)
      	echo "Only generate .mo files"
		po_gen=false
      	;;
    l)
      	echo "-l used: $OPTARG"
		LANGS=$OPTARG
      	;;
    ?) printf "Ilegal argument\n"
		printf "Usage:  $0 -pn -l <lang>\n"
# cat <<- EOF
			#$0 -pn -l <lang>
			#-p Only generate .po files
			#-m Only generate .mo files
			#-l "fr_FR"  Only use the given language(s)
# EOF	
  	    exit
      ;;
  esac
done

	echo "po_gen: $po_gen"
	echo "mo_gen: $mo_gen"

for lang in $LANGS
do
	po_dir=$cmform/locale/$lang/LC_MESSAGES
	po_file=$po_dir/messages.po
	mo_file=$po_dir/messages.mo
	if [ "$po_gen" == true ]
	then
    	printf "\nUpdating $po_file\n"
		xgettext  \
			--copyright-holder="EnfinWeb" \
			--package-name="CMform" \
			--package-version="0.1" \
			--language="PHP" \
			--msgid-bugs-address="zfadade@yahoo.com" \
			--from-code="UTF-8" \
			--omit-header \
			--join-existing  \
			-o $po_file -j $cmform/*.php 

    	printf "Converting $(basename $po_file) to $(basename $mo_file)\n"
	fi

	if [ "$mo_gen" == true ]
	then
    	printf "\nConverting $po_file to $mo_file\n"
    	msgfmt --verbose --output-file=$mo_file $po_file
		# msgfmt --check --verbose --output-file=$mo_file $po_file
	fi

done
