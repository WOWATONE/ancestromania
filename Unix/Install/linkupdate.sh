directory=`dirname $0`
echo "Working in $directory"
cd $directory 
cd ..
cd ..

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

