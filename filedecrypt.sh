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
# filedecrypt.sh
# v 0.1
# Revisions:
# ################################## 

echo local2cloud  Copyright 2013  Quintes van Aswegen
echo This program comes with ABSOLUTELY NO WARRANTY.
echo This is free software, licensed under GPLv3. 
echo You are welcome to redistribute it under certain conditions; 
echo visit http://www.gnu.org/licenses/ for more information
echo 

if [ $# -lt 2 ]
then
 echo "Usage: $0 file-to-decrypt new-file-name"
 exit 1
fi
echo [ $0 ][Info] Starting decryption..
echo [ $0 ][Info] Using password stored in `eval echo ~/.local2cloud/.encpassword`

openssl enc -d -aes256 -a -in "$1" -out "$2" -pass \
			  file:`eval echo ~/.local2cloud/.encpassword`

[ $? -ne 0 ] && { echo [ $0 ][Error] occurred with decoding of file ; exit 1; }
[ -f $2 ] || { echo "[ $0 ][Error] file $2 not found " ; exit 1; }
echo [ $0 ][Info] completed.
exit 0 
