directory=`dirname $0`
echo "Working in $directory"
cd $directory 
cd ..
cd ..

cp ./i386-win32/Ancestromania.ini ./i386-linux/
cp ./i386-win32/Ancestromania.ini ./i386-linux-k/
cp ./i386-win32/Ancestromania.ini ./x86_64-linux/
cp ./i386-win32/Ancestromania.ini ./x86_64-linux-k/
