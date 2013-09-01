#!bin/bash
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
# parts2file.sh
# v 0.1
# Revisions:
# ################################## 
echo local2cloud  Copyright 2013  Quintes van Aswegen
echo This program comes with ABSOLUTELY NO WARRANTY.
echo This is free software, licensed under GPLv3. 
echo You are welcome to redistribute it under certain conditions; 
echo visit http://www.gnu.org/licenses/ for more information
echo 
if [ $# -lt 3 ]
then
 echo "Usage: $0 folder-containing-parts folder-to-create-file new-file-name"
 exit 1
fi
echo "[ $0 ][Info] Args: $1 $2 $3"
maxfs=${LOCAL2CLOUD_FILESIZE:=50}
testfiles=${LOCAL2CLOUD_TEST:=1}
debug=${LOCAL2CLOUD_DEBUG:=0}
debugon=1
binfolder=`pwd`
listfile=".list"
[ ! -d $1 ] && { echo [ $0 ][Error] Path $1 does not exist; exit 1; }
[ -f `eval echo $2/$3` ] && rm `eval echo $2/$3`
echo "[ $0 ][Info] combining parts.."
for file in `ls $1`; 
do 		  
  #do not include temp parts list
  case "$file" in
	  *$listfile*) echo "[ $0 ][Info] $listfile found, excluding." ;;
	  *)       
	   cat $1/$file >> `eval echo $2/$3`  
	   ;;
  esac
done
echo [ $0 ][Info] file `eval echo $2/$3` completed.
exit 0
