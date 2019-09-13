SPK_NAME = paperless
SPK_VERS = 2.7.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS += cross/filemagic
DEPENDS += cross/pdftotext
DEPENDS += cross/unpaper
DEPENDS += cross/pillow
DEPENDS += cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.6.8-9"

MAINTAINER = SynoCommunity
DESCRIPTION = to be defined
RELOAD_UI = no
DISPLAY_NAME = Paperless
STARTABLE = no

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPL-3.0

WIZARDS_DIR = $(WORK_DIR)/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8880
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

PIP_WHEEL_ADDITIONAL_OPTIONS = --no-use-pep517

POST_STRIP_TARGET = paperless_generate_wizards

include ../../mk/spksrc.spk.mk

.PHONY: paperless_generate_wizards
paperless_generate_wizards:
	install -m 755 -d $(WIZARDS_DIR)
	$(RUN) ./src/wizard/gen_install_uifile.sh > $(WIZARDS_DIR)/install_uifile.sh
