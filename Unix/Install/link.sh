directory=`dirname $0`
echo "Working in $directory"
cd $directory 
cd ..
cd ..

ln -s ../i386-win32/AncestroWeb ./i386-linux/
ln -s ../i386-win32/Images ./i386-linux/
ln -s ../i386-win32/Scripts ./i386-linux/
ln -s ../i386-win32/AncestroWeb ./i386-linux-k/
ln -s ../i386-win32/Images ./i386-linux-k/
ln -s ../i386-win32/Scripts ./i386-linux-k/
ln -s ../i386-win32/AncestroWeb ./x86_64-linux/
ln -s ../i386-win32/Images ./x86_64-linux/
ln -s ../i386-win32/Scripts ./x86_64-linux/
ln -s ../i386-win32/AncestroWeb ./x86_64-linux-k/
ln -s ../i386-win32/Images ./x86_64-linux-k/
ln -s ../i386-win32/Scripts ./x86_64-linux-k/

ln -s ../Windows/Output/Update_AncestroIntel.exe ./Update/
ln -s ../Windows/Output/Update_AncestroIntel64.exe ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel.deb ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel.rpm ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel.tar.gz ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel64.deb ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel64.rpm ./Update/
ln -s ../Unix/Unsigned/Update_AncestroIntel64.tar.gz ./Update/
ln -s ../Docs/Evolutions.html ./Update/
ln -s ../Docs/Evolutions.rtf ./Update/
ln -s ../Docs/Evolutions.txt ./Update/
