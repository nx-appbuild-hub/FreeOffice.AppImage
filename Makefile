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
PWD:=$(shell pwd)

all: clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir/freeoffice
	apprepo --destination=$(PWD)/build appdir boilerplate libcurl4 openssl libidn
	echo '' 																			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/freeoffice' 					>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' 									>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'case "$$1" in' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '  "--writer") exec $${APPDIR}/freeoffice/textmaker "$${2}" ;;' 				>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '  "--spreadsheets")   exec $${APPDIR}/freeoffice/planmaker "$${2}" ;;' 		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '  "--presentation")   exec $${APPDIR}/freeoffice/presentations "$${2}" ;;' 	>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '  *)   exec $${APPDIR}/freeoffice/textmaker "$${@}" ;;' 						>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'esac' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun


	wget --output-document=$(PWD)/build/build.deb "https://www.softmaker.net/down/softmaker-freeoffice-2018_976-01_amd64.deb"
	dpkg -x $(PWD)/build/build.deb $(PWD)/build/

	
	cp --force --recursive $(PWD)/build/usr/share/freeoffice*/* $(PWD)/build/Boilerplate.AppDir/freeoffice

	rm --force $(PWD)/build/Boilerplate.AppDir/*.desktop

	cp --force $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir/
	cp --force $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir/ 	|| true
	cp --force $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir/ 	|| true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/FreeOffice.AppImage
	chmod +x $(PWD)/FreeOffice.AppImage

clean:
	rm -rf $(PWD)/build
