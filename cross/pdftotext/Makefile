PKG_NAME = pdftotext
PKG_VERS = 2.1.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jalan/$(PKG_NAME)/archive/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/poppler 

HOMEPAGE = https://github.com/jalan/pdftotext
LICENSE  = MIT

include ../../mk/spksrc.python-wheel.mk
