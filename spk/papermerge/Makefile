SPK_NAME = papermerge
SPK_VERS = 1.4.0
SPK_REV = 1
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/$(SPK_NAME) 
#DEPENDS += cross/mglib
DEPENDS += cross/stapler # Replacment for pdftk
DEPENDS += cross/poppler cross/file

WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7:tesseract-ocr>=4.0.1"

MAINTAINER = "https://papermerge.com"
DESCRIPTION = "Open Source Document Management System for Electronic Archives"
DISPLAY_NAME = Papermerge
CHANGELOG = "Initial public beta build, based on commit b9982e511c1a0f5bc52a7b3166cb3bd4426603fe (release 1.4.0)"
RELOAD_UI = no
STARTABLE = yes

BETA = 1

HOMEPAGE = https://www.papermerge.com/
LICENSE  = Apache License 2.0
REPORT_URL = https://github.com/ciur/papermerge/issues/

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8880
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_storage_path

# poppler doesn't build with ARMv5 (88f6281)
UNSUPPORTED_ARCHS = ${ARM5_ARCHES} ${PPC_ARCHES} 

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = papermerge_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: papermerge_extra_install

papermerge_extra_install:
	install -m 644 src/settings.py $(STAGING_DIR)/share/papermerge/config/settings/synology.py
	install -m 755 src/pdftk.sh $(STAGING_DIR)/bin/pdftk.sh