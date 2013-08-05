#!bin/sh -u
# Program: local2cloud. backup files to cloud storage.
#   Copyright (C) 2013  Quintes van Aswegen
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
# 
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    
# file2folder.sh
# v 0.2
# Revisions:
# 20130731 - 0.2 - update comments header
# ################################## 

echo local2cloud  Copyright 2013  Quintes van Aswegen
echo This program comes with ABSOLUTELY NO WARRANTY.
echo This is free software, licensed under GPLv3. 
echo You are welcome to redistribute it under certain conditions; 
echo visit http://www.gnu.org/licenses/ for more information
echo 
if [ $# -lt 1 ] 
then
  echo "[ $0 ][Error] Incorrect number of arguments supplied." 
  exit 1
fi

echo "[ $0 ][Info] Args: $1 "

maxfs=${LOCAL2CLOUD_FILESIZE:=100}
testfiles=${LOCAL2CLOUD_TEST:=1}
debug=${LOCAL2CLOUD_DEBUG:=0}
debugon=1
splitreq=0
echo [ $0 ][Info] LOCAL2CLOUD_FILESIZE is $maxfs, set env var LOCAL2CLOUD_FILESIZE to override.
echo [ $0 ][Info] LOCAL2CLOUD_TEST is $testfiles, set env var LOCAL2CLOUD_TEST to 0,1 to override.

binfolder=`pwd`

[ ! -d ~/.local2cloud ] && { mkdir ~/.local2cloud/;touch ~/.local2cloud/.credentials;\
						    touch ~/.local2cloud/.encpassword;\
						    touch ~/.local2cloud/.targets ;\
						    echo Credentials needed in ~/.local2cloud; exit 1;}

targetdir=`more ~/.local2cloud/.targets | awk 'NR==1 {print; exit}'`
echo "[ $0 ][Info] Files will be saved to $targetdir (~/.local2cloud/.targets)"

targetf="`eval echo $targetdir/``basename $1`.enc"
echo "[ $0 ][Info] Checking file size `basename $1`"
fs=` ls -lash $1 | awk '{print $1;}' - | sed 's/M//g' - `

case "$fs" in
	  *M*) fs=` ls -lash $1 | awk '{print $1;}' - | sed 's/M//g' - ` ;
		   echo "[ $0 ][Info] File size is ${fs}Mb." ;
		   $splitreq=1;;
	  *K*) fs=` ls -lash $1 | awk '{print $1;}' - | sed 's/K//g' - ` ;
	       fsw=`echo "$fs/1024" | bc -l`	;       
	       fs="1";
		   echo "[ $0 ][Info] File size is ${fsw}, limiting as 1Mb." ;;
	  *G*) fs=` ls -lash $1 | awk '{print $1;}' - | sed 's/\.[0-9]*G//g' - ` ;
	       fsw=`echo "$fs*1024" | bc`;
	       fsw=`expr $fs \* 1024`;        
	       fs=$fsw;
		   echo "[ $0 ][Info] File size is approx ${fsw}G." ;;		   
	  *)       
	   echo "[ $0 ][Info] File size is ${fs}Mb." ;;
	   
  esac

if [ $fs -gt $maxfs ]
then

	echo "[ $0 ][Info] making directory ~/.local2cloud/tmp"
	[ ! -d ~/.local2cloud/tmp ] && { mkdir ~/.local2cloud/tmp/ ; }
	echo "[ $0 ][Info] clearing folder"
	rm -r ~/.local2cloud/tmp/*
	targetf="`eval echo ~/.local2cloud/tmp/``basename $1`.enc"
	echo "[ $0 ][Info] encrypting to $targetf"
	openssl enc -e -aes256 -a -salt -in "$1" \
			  -out $targetf -pass \
			  file:`eval echo ~/.local2cloud/.encpassword`
	[ $? -ne 0 ] && echo [ $0 ][Error] occurred with encoding of file && exit 1
	fn=`basename $targetf | sed 's/\./_/g' -`
	cd ~/.local2cloud/tmp
	echo [ $0 ][Info] Large file will be split..
	split -b ${maxfs}m $targetf ${fn%.*}-
	echo [ $0 ][Info] split completed.
	[ $? -ne 0 ] && echo [ $0 ][Error] large file split failed. Exitting. && exit 1

	[ "${LOCAL2CLOUD_DEBUG}" -eq "$debugon" ] && ls ~/.local2cloud/tmp
	btestfiles="1"
	if [ $testfiles -eq $btestfiles ] 
	then
		echo [ $0 ][Info] Testing Started...
		testfile=`eval echo ~/.local2cloud/tmp/test``basename $1`".enc"
		filenamecmp=`basename $targetf`
		
		[ -f $testfile ] && rm $testfile
		
		for file in `ls ~/.local2cloud/tmp`; 
		do 		  
		  if [ $file != $filenamecmp  ] 
		  then
		    echo "${file}" >> `eval echo ~/.local2cloud/tmp/``basename $1`.list 
			cat ~/.local2cloud/tmp/$file >> $testfile		
		  fi   
		done
		
		[ "${LOCAL2CLOUD_DEBUG}" -eq "$debugon" ] && \
			echo `basename $targetf` to compare md5 to `basename $testfile` || echo [ $0 ][Info] comparing md5...
		file1hash=`md5sum $targetf | awk '{print $1;}' - `	
		file2hash=`md5sum $testfile | awk '{print $1;}' - `		
		if [ "${LOCAL2CLOUD_DEBUG}" -eq "$debugon" ] 
		then
			[ $file1hash = $file2hash ] && echo [ $0 ][Info] `basename $targetf` hash matches `basename $testfile` 
		else
		    [ $file1hash = $file2hash ] && echo [ $0 ][Info] md5 checks ok
		fi
		
		[ $file1hash != $file2hash ] && { echo "[ $0 ][Error] Hash mismatch. Testing failure" ; exit 2; }
		[ -f $testfile ] && rm $testfile
		echo [ $0 ][Info] Testing Completed
	fi
	[ -f $targetf ] && rm $targetf
	targetf="`eval echo $targetdir/`${fn%.*}"
	
	[ ! -d $targetf ] && { mkdir $targetf ; }
	rm -r $targetf/*
	cp ~/.local2cloud/tmp/* $targetf/
	cd $binfolder
	
else
	echo "[ $0 ][Info] encrypting regular step to $targetf"
	openssl enc -e -aes256 -a -salt -in "$1" \
			  -out $targetf -pass \
			  file:`eval echo ~/.local2cloud/.encpassword`
	[ $? -ne 0 ] && echo [Error] occurred with encoding of file && exit 1
	[ -f $targetf ] ||  echo "[ $0 ][Error] file $targetf not found " && exit 1
fi

[ "${LOCAL2CLOUD_DEBUG}" -eq "$debugon" ] && echo "[ $0 ][Info] copy and encoding $1 completed."
[ "${LOCAL2CLOUD_DEBUG}" -eq "$debugon" ] || echo "[ $0 ][Info] copy and encoding `basename $1` completed."


	 

