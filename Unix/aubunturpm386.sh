#!/bin/bash
# create debian, redhat and tar.gz packages

# Initing

directory=`dirname $0`
echo "Working in $directory"
cd $directory 
sudo chown -R $USERNAME Update_AncestroIntel.orig/
sudo chown -R $USERNAME Update_AncestroIntel.tar/
sudo chmod 644 ../i386-win32/Scripts/*

./version.sh ./Update_AncestroIntel/debian/control ../i386-linux/Ancestromania.ini

# Preparing executable package

rm Update_AncestroIntel/usr/share/ancestromania/Ancestromania
cp ../i386-linux/Ancestromania.ini Update_AncestroIntel/usr/share/ancestromania
cp ../i386-linux/Ancestromania Update_AncestroIntel.tar
cp ../i386-linux/Ancestromania.ini Update_AncestroIntel.tar
cp ../i386-win32/Scripts/* Update_AncestroIntel/usr/share/ancestromania/Scripts
cp ../i386-win32/Scripts/* Update_AncestroIntel.tar/Scripts

cp ../Docs/Evolutions.html Update_AncestroIntel/usr/share/doc/ancestromania/

tar -czvf  Update_AncestroIntel.orig/Ancestromania.tar.gz Update_AncestroIntel/usr
tar -czvf  Update_AncestroIntel.orig/Resources.tar.gz ../Resources
tar -czvf  Update_AncestroIntel.orig/Packages.tar.gz --exclude=*/lib/* ../Packages
tar -czvf  Update_AncestroIntel.orig/Plugins.tar.gz --exclude=../Plugins/lib/* ../Plugins

cp ../i386-linux/Ancestromania Update_AncestroIntel/usr/share/ancestromania

#sudo chown -R root:root Update_AncestroIntel.orig/

#tar -czvf ancestromania-gnome_$version.orig.tar.gz Update_AncestroIntel.orig
# Buiding .dsc

cd Update_AncestroIntel

debuild -S -sa --source-option=--include-binaries --lintian-opts -i

cd ..

# Creating packages

sudo  chmod 644 Update_AncestroIntel/usr/share/ancestromania/Scripts/*
sudo  chmod 644 Update_AncestroIntel.tar/Scripts/*
sudo chown -R root:root Update_AncestroIntel
sudo pbuilder build ancestromania-gnome*.dsc
sudo cp /var/cache/pbuilder/trusty-i386/result/ancestromania-gnome*.* ./
sudo chown -R $USERNAME Update_AncestroIntel
sudo chown $USERNAME ancestromania-gnome*.*
exit
cp ancestromania-gnome*i386*.deb Update_AncestroIntel.deb
rm *el.rpm
sudo alien -r --scripts Update_AncestroIntel.deb
sudo chown $USERNAME *.rpm
mv *i386*.rpm Update_AncestroIntel.rpm
sudo chown -R root.root Update_AncestroIntel.tar
sudo tar -czvf Update_AncestroIntel.tar.gz Update_AncestroIntel.tar
sudo chown -R $USERNAME Update_AncestroIntel.tar

