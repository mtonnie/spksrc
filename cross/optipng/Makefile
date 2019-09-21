PKG_NAME = optipng
PKG_VERS = 0.7.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.sourceforge.net/optipng
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib
DEPENDS += cross/libpng

HOMEPAGE = http://optipng.sourceforge.net/
COMMENT = a PNG optimizer that recompresses image files to a smaller size, without losing any information
LICENSE = http://optipng.sourceforge.net/license.txt

CONFIGURE_TARGET = optipng_custom_configure
POST_CONFIGURE_TARGET = optipng_post_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: optipng_custom_configrue optipng_post_configure
optipng_custom_configure:
	$(RUN) ./configure -with-system-libs

optipng_post_configure:
	$(RUN) sed -i 's/$$(LD)/$$(CC) -o/' $(WORK_DIR)/$(PKG_DIR)/src/optipng/Makefile
