#!/bin/bash
# create debian, redhat and tar.gz packages

# Initing

directory=`dirname $0`
echo "Working in $directory"
cd $directory 

# Preparing

mkdir Ancestromania-data.orig

if [ ! -d ./Ancestromania-data/var/ ]; then
	mkdir Ancestromania-data/src/
	chmod -R 775 Ancestromania-data/src/
fi

cp ../i386-win32/MaBase.fdb Ancestromania-data/src/Ancestromania-updated.fdb
cp ../i386-win32/Parances.fdb Ancestromania-data/src/Parances.fdb

rm Ancestromania-data.orig/*.sql
isql-fb -a -ch utf8 -o 'Ancestromania-data.orig/Ancestromania.sql' 'Ancestromania-data/src/Ancestromania-updated.fdb'
isql-fb -a -ch utf8 -o 'Ancestromania-data.orig/Parances.sql' 'Ancestromania-data/src/Parances.fdb'
tar -czvf Ancestromania-data.orig.tar.gz Ancestromania-data.orig

cp Ancestromania-data/var/lib/firebird/2.5/data/* Update_AncestroIntel.tar

# Buiding .dsc

cd Ancestromania-data

debuild -S -sa --source-option=--include-binaries --lintian-opts -i

cd ..

# Creating packages

sudo  chmod 664 Ancestromania-data/var/lib/firebird/2.5/data/*.fdb
sudo  chmod 666 Update_AncestroIntel.tar/*.fdb
sudo chown -R root:root Ancestromania-data
sudo pbuilder build ancestromania-data*.dsc
sudo cp /var/cache/pbuilder/trusty-i386/result/ancestromania-data*.* ./
sudo cp ancestromania-data*.deb Ancestromania-data.deb
sudo chown -R $USERNAME Ancestromania-data
sudo chown $USERNAME ?ncestromania-data*.*
rm *data.rpm
sudo alien -r --scripts Ancestromania-data.deb
sudo chown $USERNAME *.rpm
mv *noarch*.rpm Ancestromania-data.rpm

