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
# folder2cloud.sh
# v 0.1
# Revisions:
# ################################## 

echo local2cloud  Copyright 2013  Quintes van Aswegen
echo This program comes with ABSOLUTELY NO WARRANTY.
echo This is free software, licensed under GPLv3. 
echo You are welcome to redistribute it under certain conditions; 
echo visit http://www.gnu.org/licenses/ for more information

if [ $# -lt 2 ] 
then
  echo Incorrect number of arguments supplied. Supply SRC directory.
  echo All files with pattern in  argument 2 will be processed
  echo e.g. $0 ~/somefolder "*.jpg"
  exit 1
fi
echo "[ $0 ][Info] Args: $1 | $2"
targetdir=`more ~/.local2cloud/.targets | awk 'NR==1 {print; exit}'`
for file in `eval echo $1/$2`; 
do 
  sh file2folder.sh "$file"; 
done
