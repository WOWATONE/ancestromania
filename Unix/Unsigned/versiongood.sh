#!/bin/bash
# update version in debian packages

# extract integer
function extractnumber {
number=`echo $1 | sed 's/[^0-9]//g'` 
}

# modifiy DEBIAN/control file of package
function changefileversion {
if [[ ! -f "$1" ]]; then
return 1
fi
if [[ -f "$2" ]]; then
rm $2
fi
echo "Changing Version of file $1 to $3."
cat $1 | while myLine=`line`
  do
     if [[ -n `echo $myLine | grep Version` ]]; then
	echo "Version: $3" >> $2
	else echo "$myLine" >> $2
     fi
  done
rm $1
mv $2 $1
}

# get version in Inifile
# Exemple :
# Major = 2014
# Minor = 2
function getversion {
version_major="?"
version_minor="?"
version_revision="?"
version_build="?"
while read line           
  do  
     if [[ -n `echo $line | grep Major` ]]; then
	extractnumber $line
	version_major=$number
	else 
     if [[ -n `echo $line | grep Minor` ]]; then
	extractnumber $line
	version_minor=$number
	else 
     if [[ -n `echo $line | grep Revision` ]]; then
	extractnumber $line
	version_revision=$number
	else 
     if [[ -n `echo $line | grep Build` ]]; then
	extractnumber $line
	version_build=$number 
     fi
     fi
     fi
     fi
  done < $1
version="$version_major.$version_minor.$version_revision.$version_build"
}
getversion $2
changefileversion $1 "/tmp/version_file$version" $version

