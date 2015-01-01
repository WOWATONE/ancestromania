directory=`dirname $0`
echo "Working in $directory"
cd $directory 
cd ..
cd ..

ln -s ../i386-win32/AncestroWeb ./i386-linux/AncestroWeb
ln -s ../i386-win32/Images ./i386-linux/Images
ln -s ../i386-win32/Scripts ./i386-linux/Scripts
ln -s ../i386-win32/AncestroWeb ./i386-linux-k/AncestroWeb
ln -s ../i386-win32/Images ./i386-linux-k/Images
ln -s ../i386-win32/Scripts ./i386-linux-k/Scripts
ln -s ../i386-win32/AncestroWeb ./x86_64-linux/AncestroWeb
ln -s ../i386-win32/Images ./x86_64-linux/Images
ln -s ../i386-win32/Scripts ./x86_64-linux/Scripts
ln -s ../i386-win32/AncestroWeb ./x86_64-linux-k/AncestroWeb
ln -s ../i386-win32/Images ./x86_64-linux-k/Images
ln -s ../i386-win32/Scripts ./x86_64-linux-k/Scripts

