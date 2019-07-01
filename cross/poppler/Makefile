PKG_NAME = poppler
PKG_VERS = 0.69.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://$(PKG_NAME).freedesktop.org

PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/fontconfig cross/libiconv cross/libjpeg cross/libxml2 cross/openjpeg cross/zlib

HOMEPAGE = https://poppler.freedesktop.org/
COMMENT  = Poppler is a PDF rendering library based on the xpdf-3.0 code base. 
LICENSE  = ???

CONFIGURE_TARGET = myConfigure

CMAKE_ARGS = -DCMAKE_INSTALL_PREFIX=$(INSTALL_PREFIX)
CMAKE_ARGS += -DBUILD_TESTS=OFF

include ../../mk/spksrc.cross-cc.mk

myConfigure:
	$(RUN) cmake $(CMAKE_ARGS)

