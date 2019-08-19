PKG_NAME = file
PKG_VERS = 5.30
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.astron.com/pub/file
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.darwinsys.com/file/
COMMENT  = The file command is "a file type guesser", that is, a command-line tool that tells you in words what kind of data a file contains.
LICENSE  = BSD-2-Clause

GNU_CONFIGURE = 1

CONFIGURE_ARGS += --prefix=$(INSTALL_PREFIX) --enable-shared

include ../../mk/spksrc.cross-cc.mk
