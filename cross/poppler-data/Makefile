PKG_NAME = poppler-data
PKG_VERS = 0.4.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://poppler.freedesktop.org

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://poppler.freedesktop.org/
COMMENT  = encoding files for use with poppler. The encoding files are optional and poppler will automatically read them if they are present. 
LICENSE  = MIT / ADOPT / GPLv2

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = poppler-data_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: poppler-data_custom_install
	
poppler-data_custom_install:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)