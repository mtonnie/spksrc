PKG_NAME = python
PKG_VERS = 3.7.7
PKG_EXT = tar.xz
PKG_DIST_NAME = Python-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.python.org/ftp/python/$(PKG_VERS)
PKG_DIR = Python-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.python.org/
COMMENT  = Python Programming Language
LICENSE  = PSF

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-ipv6 --without-ensurepip

COMPILE_TARGET = nativepython3_custom_compile
POST_INSTALL_TARGET = nativepython3_post_install

include ../../mk/spksrc.native-cc.mk

.PHONY: nativepython3_custom_compile
nativepython3_custom_compile:
	@$(RUN) $(MAKE) Parser/pgen all

PYTHON = $(WORK_DIR)/install/usr/local/bin/python3
PIP = $(WORK_DIR)/install/usr/local/bin/pip
PIP_NATIVE = $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/pip

.PHONY: nativepython3_post_install
nativepython3_post_install: $(WORK_DIR)/python-native.mk
	@$(MSG) Installing pip, setuptools, cffi and cross env
	@$(RUN) wget https://bootstrap.pypa.io/get-pip.py -O - | $(PYTHON)
	@$(PIP) install "setuptools==44.1.0"
	@$(PIP) install "cffi==1.14.0"
	@$(PIP) install "crossenv==0.7"

$(WORK_DIR)/python-native.mk:
	@echo PIP=$(PIP_NATIVE) >> $@
