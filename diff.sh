#!/bin/bash

if [[ $# -lt 3 ]]
then
	echo Usage: sh `basename $0` /path/to/old.csv /path/to/new.csv /path/to/diff.csv
	exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DB=$DIR/temp.db
KEY=$(head -1 $1 | cut -d ',' -f1)

echo [$(date)] start. key is $KEY
if [ -f $DB ]; then rm $DB; fi

# import old.csv and new.csv files to sqlite, perform diff, then export sqlite to diff.csv
echo '.mode csv\n.import '$1' old\n.import '$2' new' | sqlite3 $DB
echo '.header on\n.mode csv\n.once '$3 | cat - $DIR/script.sql | sed -e "s/\${key}/$KEY/" | sqlite3 $DB

if [ -f $DB ]; then rm $DB; fi
echo [$(date)] done.
