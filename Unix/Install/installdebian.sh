#!/bin/bash
# install pbuilder to create debian, redhat and tar.gz packages

# Initing

directory=`dirname $0`
echo "Working in $directory"
cd $directory 

# Parameters

cp ./_pbuilderrc $HOME/.pbuilderrc
cp -R ./_gnupg $HOME/.gnupg

# Installing structure
sudo apt-get install debhelper cdbs lintian build-essential fakeroot devscripts pbuilder dh-make debootstrap quilt

sudo pbuilder create

sudo pbuilder update --extrapackages flamerobin lazarus debhelper fakeroot

exit 0
