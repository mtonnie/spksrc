SPK_NAME = paperless
SPK_VERS = 2.7.0+git
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

BETA = 1

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS += cross/ghostscript
DEPENDS += cross/filemagic
DEPENDS += cross/pdftotext
DEPENDS += cross/unpaper
DEPENDS += cross/pillow
DEPENDS += cross/optipng
DEPENDS += cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.5.6-8:tesseract-ocr>=4.1.0-1:imagemagick>=7.0.8-4"

MAINTAINER = SynoCommunity
DESCRIPTION = to be defined
RELOAD_UI = yes
DISPLAY_NAME = Paperless
STARTABLE = yes

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPL-3.0

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8880
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
SERVICE_WIZARD_SHARE = wizard_storage_path

PIP_WHEEL_ADDITIONAL_OPTIONS = --no-use-pep517

include ../../mk/spksrc.spk.mk
