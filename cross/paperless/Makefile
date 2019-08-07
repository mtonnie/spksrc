PKG_NAME = paperless
PKG_VERS = 2.7.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/the-paperless-project/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://paperless.readthedocs.io
LICENSE  = GPLv3

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
WHEELS += attrs==18.2.0
WHEELS += pluggy==0.8.1
WHEELS += pytest-xdist==1.26.0
WHEELS += pytest==4.1.1
WHEELS += python-dateutil==2.7.5
WHEELS += tox==3.7.0
WHEELS += virtualenv==16.3.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = paperless_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: paperless_custom_install
paperless_custom_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/paperless
	cp -r  $(WORK_DIR)/$(PKG_DIR)/src/* $(STAGING_INSTALL_PREFIX)/share/paperless/
	rm  $(STAGING_INSTALL_PREFIX)/share/paperless/tox.ini
	rm  $(STAGING_INSTALL_PREFIX)/share/paperless/setup.cfg