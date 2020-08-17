PKG_NAME = papermerge
PKG_VERS = b9982e511c1a0f5bc52a7b3166cb3bd4426603fe
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ciur/papermerge/archive/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/ciur/papermerge
COMMENT  = Open Source Document Management System for Electronic Archives
LICENSE  = Apache-2.0 License

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = papermerge_custom_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: papermerge_custom_install
papermerge_custom_install:
	mkdir -p $(STAGING_INSTALL_PREFIX)/share/papermerge
	cp -r  $(WORK_DIR)/$(PKG_DIR)/* $(STAGING_INSTALL_PREFIX)/share/papermerge/
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/.github
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/artwork
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/config/settings/dev.py
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/config/settings/development.example.py
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/config/settings/devtmp.py
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/config/settings/test.py
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/docker
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/docs
	#rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/example_data
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/requirements
	rm  -rf $(STAGING_INSTALL_PREFIX)/share/papermerge/screenshots
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/.gitignore
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/.travis.yml
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/MANIFEST.in
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/papermerge.conf.py.example
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/run_tests.sh
	rm  -f $(STAGING_INSTALL_PREFIX)/share/papermerge/setup.py