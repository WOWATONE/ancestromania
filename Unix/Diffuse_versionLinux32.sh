#!/bin/bash
# diffuse inc extended files

directory=`dirname $0`
echo "Working in $directory"
cd $directory


cp ../i386-linux/Ancestromania.ini  ../i386-win32/Ancestromania.ini 
cp ../i386-linux/Ancestromania.ini  ../i386-linux-k/Ancestromania.ini 
cp ../i386-linux/Ancestromania.ini  ../x86_64-linux/Ancestromania.ini 
cp ../i386-linux/Ancestromania.ini  ../x86_64-linux-k/Ancestromania.ini 
cp ../i386-linux/Ancestromania.ini  ../x86_64-win64/Ancestromania.ini 

