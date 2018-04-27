#!/bin/bash

# (C) Joel Schneider 2017-8
# Convert Outlook email to a format readable in Thunderbird/on linux etc.
# version 0.2
# License: GPL 3
# TODO: allow directly moving to Thunderbird profile folder
# Credits:
# 	readpst/libpst on SlackBuilds.org
# 	http://colby.id.au/importing-pst-files-into-thunderbird-using-libpst/
# Outlook emails can be exported en mass to PST
# But how to import to Thunderbird (or read on linux)?
# After some Googling, I came up with this solution:


function usage {
	echo -e "Usage:\t$0 [-v] file.pst [folder]"
	echo -e "\t\t-v\tverbose"
	echo -e "\t\tfolder\tdefault output folder: output"
	echo -e "\nMove the resultant files in the \"folder\" to your Thunderbird profile, likely to be something like: /home/$LOGNAME/.thunderbird/????????.default/Mail/localhost"
	#echo -e "Suggestion: create a separate account"
	exit 1
}

if [ "x$1" == "-v" ]; then
	VERBOSE="yes"
	shift
else
	VERBOSE="no"
fi

if [ "x$1" == "x" ]; then
	usage
else
	PSTFILE="$1"
	TEMPFOLDER="outlooking.$RANDOM"
fi

if [ "x$2" == "x" ]; then
	OUTFOLDER="output"
else
	OUTFOLDER="$2"
fi

mkdir $TEMPFOLDER
if [ $VERBOSE == "yes" ]; then
	readpst -rb -o "$TEMPFOLDER" "$PSTFILE"
else
	readpst -rb -o "$TEMPFOLDER" "$PSTFILE" > /dev/null
fi

cd $TEMPFOLDER
mv "Personal Folders" "out"
find out -type d | tac | grep -v '^out$' | xargs -d '\n' -I{} mv {} {}.sbd
find out -name mbox -type f | xargs -d '\n' -I{} echo '"{}" "{}"' | sed -e 's/\.sbd\/mbox"$/"/' | xargs -L 1 mv
find out -empty -type d | xargs -d '\n' rmdir
cd ..
mkdir $OUTFOLDER
mv $TEMPFOLDER/out/* $OUTFOLDER
#ls $OUTFOLDER
rm -R $TEMPFOLDER
echo "Done"
