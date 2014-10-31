#!/bin/bash
# create debian, redhat and tar.gz packages

directory=`dirname $0`
echo "Working in $directory"
cd $directory 
./version.sh ./Update_AncestroIntel/DEBIAN/control ./../../i386-linux/Ancestromania.ini
cp ../../i386-linux/Ancestromania Update_AncestroIntel/usr/share/ancestromania
cp ../../i386-linux/Ancestromania.ini Update_AncestroIntel/usr/share/ancestromania
cp ../../i386-linux/Ancestromania Update_AncestroIntel.tar
cp ../../i386-linux/Ancestromania.ini Update_AncestroIntel.tar
cp ../../i386-linux/Scripts/* Update_AncestroIntel/usr/share/ancestromania/Scripts
cp ../../i386-linux/Scripts/* Update_AncestroIntel.tar/Scripts
sudo  chmod 644 Update_AncestroIntel/usr/share/ancestromania/Scripts/*
sudo  chmod 644 Update_AncestroIntel.tar/Scripts/*
sudo  chmod 644 ../../i386-linux/Scripts/*
sudo chown -R root.root Update_AncestroIntel
sudo dpkg-deb -b Update_AncestroIntel 
sudo chown -R matthieu Update_AncestroIntel
sudo chown matthieu *.deb
rm *el.rpm
sudo alien -r --scripts Update_AncestroIntel.deb
sudo chown matthieu *.rpm
mv *i386*.rpm Update_AncestroIntel.rpm
tar -czvf Update_AncestroIntel.tar.gz Update_AncestroIntel.tar

