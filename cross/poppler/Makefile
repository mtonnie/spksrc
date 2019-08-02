PKG_NAME = poppler
PKG_VERS = 0.76.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_NAME).freedesktop.org

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/fontconfig cross/libiconv cross/libjpeg cross/libxml2 cross/openjpeg cross/zlib

HOMEPAGE = https://poppler.freedesktop.org/
COMMENT  = Poppler is a PDF rendering library based on the xpdf-3.0 code base. 
LICENSE  = ???

CONFIGURE_TARGET = poppler_custom_configure

CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=/
CMAKE_ARGS += -DCMAKE_BUILD_TYPE=release
#CMAKE_ARGS += -DDEST_DIR=/
#CMAKE_ARGS += -DBUILD_GTK_TESTS=OFF
#CMAKE_ARGS += -DBUILD_QT5_TESTS=OFF
#CMAKE_ARGS += -DBUILD_CPP_TESTS=OFF

include ../../mk/spksrc.cross-cc.mk

.PHONY: poppler_custom_configure
poppler_custom_configure:
	$(RUN) printenv
	$(RUN) cmake $(CMAKE_ARGS) -DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)
