PKG_NAME = openjpeg
PKG_VERS = 2.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/uclouvain/openjpeg/archive/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/libtiff

HOMEPAGE = http://www.openjpeg.org/
COMMENT  = The OpenJPEG library is an open-source JPEG 2000 codec written in C language.
LICENSE  = BSD

CONFIGURE_TARGET = openjpeg_custom_configure
POST_INSTALL_TARGET = openjpeg_post_install

CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: openjpeg_custom_configure
openjpeg_custom_configure:
	$(RUN) printenv
	$(RUN) cmake $(CMAKE_ARGS)

.PHONY: openjpeg_post_install
openjpeg_post_install:
	$(RUN) sed -i '/prefix=/c\prefix='"${INSTALL_DIR}${INSTALL_PREFIX}" "${INSTALL_DIR}${INSTALL_PREFIX}/lib/pkgconfig/libopenjp2.pc"



