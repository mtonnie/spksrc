PKG_NAME = unpaper
PKG_VERS = 6.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.flameeyes.eu/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/ffmpeg

HOMEPAGE = https://www.flameeyes.eu/projects/unpaper
COMMENT  = unpaper is a post-processing tool for scanned sheets of paper, especially for book pages that have been scanned from previously created photocopies.  The main purpose is to make scanned book pages better readable on screen after conversion to PDF. Additionally, unpaper might be useful to enhance the quality of scanned pages before performing optical character recognition (OCR). 
LICENSE  = GPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
