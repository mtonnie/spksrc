PKG_NAME = filemagic
PKG_VERS = 1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/f/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/file 

HOMEPAGE = https://filemagic.readthedocs.io/en/latest/
LICENSE  = Apache License 2.0 

COMPILE_TARGET = filemagic_custom_compile

include ../../mk/spksrc.python-wheel.mk

.PHONY: filemagic_custom_compile
filemagic_custom_compile:
	$(RUN) PYTHONPATH=$(PYTHONPATH) $(HOSTPYTHON) setup.py bdist_wheel -b $(WORK_DIR)/wheelbuild -d $(WORK_DIR)/wheelhouse
