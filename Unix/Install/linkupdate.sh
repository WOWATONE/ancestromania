directory=`dirname $0`
echo "Working in $directory"
cd $directory 
cd ..
cd ..

ln -s ../Windows/Output/Update_AncestroIntel.exe ./Inis/
ln -s ../Windows/Output/Update_AncestroIntel64.exe ./Inis/
ln -s ../Update_AncestroIntel.deb ./Inis/
ln -s ../Update_AncestroIntel.rpm ./Inis/
ln -s ../Update_AncestroIntel.tar.gz ./Inis/
ln -s ../Update_AncestroIntel64.deb ./Inis/
ln -s ../Update_AncestroIntel64.rpm ./Inis/
ln -s ../Update_AncestroIntel64.tar.gz ./Inis/
ln -s ../Docs/Evolutions.html ./Inis/
ln -s ../Docs/Evolutions.rtf ./Inis/
