local2cloud
===========

A set of BASH scripts supporting local file archive and encryption for cloud-based archiving purposes. 

## License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
 
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Usage

Clone this repo to your local nix box.

Run `sh folder2cloud.sh ~/path/to/file "file*.*"` to create the ~/.local2cloud folder and files.
Open `~/.local2cloud/.encpassword` in nano and enter your password to use for encryption. Save and close.
This version primarily moves files to Dropbox - Open `~/.local2cloud/.targets` in nano,
and on the first line type in the pathto your  dropbox folder, e.g ~/Dropbox/backup/
Run the command `sh folder2cloud.sh ~/path/to/file "file*.*"` again.
The std out should indicate that the file is encrypted via openssl and moved to your chosen folder.

## folder2cloud.sh {1} {2}
1. `path` should be the path to the file(s) you want to encrypt.
2. the wildcard to use when determining which files to manage.

end of document.

