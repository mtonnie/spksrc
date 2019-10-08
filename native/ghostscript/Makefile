PKG_NAME = ghostscript
PKG_VERS = 9.27
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ghostscript.com/
COMMENT = An interpreter for the PostScript language and for PDF
LICENSE = GNU Affero General Public License


GNU_CONFIGURE = 1

COMPILE_TARGET = ghostscript_custom_compile

include ../../mk/spksrc.native-cc.mk

.PHONY: ghostscript_custom_compile
ghostscript_custom_compile:
	$(RUN) make obj/aux/genarch
	$(RUN) make obj/aux/genconf
	$(RUN) make obj/aux/mkromfs
	$(RUN) make obj/aux/echogs
	$(RUN) make obj/aux/gendev
#	$(RUN) make obj/aux/genht
	$(RUN) make obj/aux/packps
