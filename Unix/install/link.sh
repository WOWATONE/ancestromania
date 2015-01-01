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
cp ./i386-win32/Ancestromania.ini ./i386-linux/
cp ./i386-win32/Ancestromania.ini ./i386-linux-k/
cp ./i386-win32/Ancestromania.ini ./x86_64-linux/
cp ./i386-win32/Ancestromania.ini ./x86_64-linux-k/
