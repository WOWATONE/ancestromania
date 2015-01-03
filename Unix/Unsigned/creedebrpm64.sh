#!/bin/bash
# create debian, redhat and tar.gz packages

directory=`dirname $0`
echo "Working in $directory"
cd $directory 
./version.sh ./Update_AncestroIntel64/DEBIAN/control ./../../x86_64-linux/Ancestromania.ini
cp ../../x86_64-linux/Ancestromania Update_AncestroIntel64/usr/share/ancestromania
cp ../../x86_64-linux/Ancestromania.ini Update_AncestroIntel64/usr/share/ancestromania
cp ../../x86_64-linux/Ancestromania Update_AncestroIntel64.tar
cp ../../x86_64-linux/Ancestromania.ini Update_AncestroIntel64.tar
cp ../../x86_64-linux/Scripts/* Update_AncestroIntel64/usr/share/ancestromania/Scripts
cp ../../x86_64-linux/Scripts/* Update_AncestroIntel64.tar/Scripts
sudo chown -R root Update_AncestroIntel64
sudo  chmod 644 Update_AncestroIntel64/usr/share/ancestromania/Scripts/*
sudo  chmod 644 Update_AncestroIntel64.tar/Scripts/*
sudo  chmod 666 Update_AncestroIntel64.tar/*.fdb
sudo dpkg-deb -b Update_AncestroIntel64 
sudo chown -R matthieu Update_AncestroIntel64
rm *el64.rpm
sudo chown matthieu *.deb
sudo alien -r -c -v Update_AncestroIntel64.deb
sudo chown matthieu *.rpm
mv *x86_64*.rpm Update_AncestroIntel64.rpm
tar -czvf Update_AncestroIntel64.tar.gz Update_AncestroIntel64.tar

