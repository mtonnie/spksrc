SPK_NAME = paperless
SPK_VERS = 2.7.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS += cross/pdftotext
DEPENDS += cross/unpaper
DEPENDS += cross/pillow
DEPENDS += cross/$(SPK_NAME)
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.5.6-8"

MAINTAINER = SynoCommunity
DESCRIPTION = to be defined
RELOAD_UI = no
DISPLAY_NAME = Paperless
STARTABLE = no

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPL-3.0

PIP_WHEEL_ADDITIONAL_OPTIONS = --no-use-pep517

include ../../mk/spksrc.spk.mk