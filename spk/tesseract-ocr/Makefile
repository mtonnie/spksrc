SPK_NAME = tesseract-ocr
SPK_VERS = 4.1.0
SPK_REV = 1

BETA=1

DEPENDS = cross/${SPK_NAME}

MAINTAINER = SynoCommunity
DESCRIPTION = Open Source OCR Engine
DISPLAY_NAME = Tesseract OCR

CHANGELOG = "Initial version"

HOMEPAGE = https://github.com/tesseract-ocr
LICENSE  = Apache License 2.0

WIZARDS_DIR = src/wizard/

STARTABLE = no
SERVICE_SETUP = src/service-setup.sh

# tesseract doesn't build with ARMv5 (88f6281) missing c++11 support
UNSUPPORTED_ARCHS = ${ARM5_ARCHES} ${PPC_ARCHES} 

include ../../mk/spksrc.spk.mk