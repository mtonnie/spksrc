SPK_NAME = papermerge
SPK_VERS = 1.4.0.rc3
SPK_REV = 1
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/$(SPK_NAME) cross/mglib
DEPENDS += cross/poppler

WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7:tesseract-ocr>=4.0.1:imagemagick>=7.0.8"

MAINTAINER = tbd
DESCRIPTION = tbc
DISPLAY_NAME = Papermerge
CHANGELOG = "Inital package release"
RELOAD_UI = no
STARTABLE = yes

BETA = 1

HOMEPAGE = https://www.papermerge.com/
LICENSE  = Apache License 2.0

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8880
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_storage_path

# ppc archs except QorIQ
UNSUPPORTED_ARCHS = ${PPC_ARCHES}

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = papermerge_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: papermerge_extra_install

papermerge_extra_install:
	install -m 644 src/settings.py $(STAGING_DIR)/share/papermerge/config/settings/synology.py