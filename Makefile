# This software is a part of the A.O.D apprepo project
# Copyright 2015 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
SOURCE="https://www.freeoffice.com/download.php?filename=https://www.softmaker.net/down/softmaker-freeoffice-2018_976-01_amd64.deb"
DESTINATION="build.deb"
OUTPUT="FreeOffice.AppImage"

all:
	echo "Building: $(OUTPUT)"
	wget --output-document=$(DESTINATION) --continue $(SOURCE)
	dpkg -x $(DESTINATION) build

	wget --output-document=build.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/libcurl-7.61.1-12.el8.x86_64.rpm
	rpm2cpio build.rpm | cpio -idmv

	wget --output-document=build.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-libs-1.0.2k-19.el7.x86_64.rpm
	rpm2cpio build.rpm | cpio -idmv

	wget --output-document=build.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/libidn-1.28-4.el7.x86_64.rpm
	rpm2cpio build.rpm | cpio -idmv

	mkdir -p ./AppDir/lib
	mkdir -p ./AppDir/application
	cp -r ./usr/lib64/* ./AppDir/lib
	cp -r ./build/usr/share/freeoffice*/* ./AppDir/application

	export ARCH=x86_64 && bin/appimagetool.AppImage AppDir $(OUTPUT)
	chmod +x $(OUTPUT)

	rm -rf *.deb
	rm -rf *.rpm
	rm -rf ./build
	rm -rf ./usr
	rm -rf ./etc
	rm -rf ./AppDir/application
	rm -rf ./AppDir/lib
