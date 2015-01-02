#!/bin/sh
# postinst script for ancestromania-data
#

directory=`dirname $0`
echo "Working in $directory"
cd $directory 

chmod 660 ./Ancestromania-updated.fdb 
chmod 660 ./Parances.fdb 

## get UID limit ##
l=$(grep "^UID_MIN" /etc/login.defs)

## use awk to print if UID >= $UID_LIMIT ##
for USER in `awk -F':' -v "limit=${l##UID_MIN}" '{ if ( $3 >= limit ) print $1}' /etc/passwd`;do
	echo "setting $USER as firebird member"
	usermod -a -G firebird $USER
done

if [ ! -e "/etc/firebird/2.5/SYSDBA.password" ]; then
	echo "Creating 8 chars admin password"
	gsec -user sysdba -mo sysdba -pw masterke
fi

exit 0
