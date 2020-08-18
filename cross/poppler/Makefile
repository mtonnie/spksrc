PKG_NAME = poppler
PKG_VERS = 0.76.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_NAME).freedesktop.org

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

#BUILD_DEPENDS = cross/fontconfig cross/libjpeg cross/libxml2 cross/zlib
DEPENDS = cross/poppler-data cross/libiconv cross/openjpeg 
DEPENDS += cross/fontconfig cross/libjpeg cross/libxml2 cross/zlib

HOMEPAGE = https://poppler.freedesktop.org/
COMMENT  = Poppler is a PDF rendering library based on the xpdf-3.0 code base. 
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = ${ARM5_ARCHES}

CONFIGURE_TARGET = poppler_custom_configure
INSTALL_TARGET = poppler_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: poppler_custom_configure poppler_custom_install
poppler_custom_configure:
	$(RUN) cmake \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX) \
	-DCMAKE_CROSSCOMPILING=TRUE \
	-DCMAKE_FIND_ROOT_PATH=$(INSTALL_DIR)$(INSTALL_PREFIX) \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
	
poppler_custom_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)