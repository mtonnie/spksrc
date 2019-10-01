PKG_NAME = ghostscript
PKG_VERS = 9.27
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)


#DEPENDS += cross/cairo
#DEPENDS += cross/freetype
#DEPENDS += cross/libjpeg
#DEPENDS += cross/libtiff
#DEPENDS += cross/openjpeg
#DEPENDS += cross/libpng

HOMEPAGE = https://www.ghostscript.com/
COMMENT = An interpreter for the PostScript language and for PDF
LICENSE = GNU Affero General Public License


GNU_CONFIGURE = 1
CONFIGURE_ARGs += -without-x
CONFIGURE_ARGS += --with-drivers=FILES
CONFIGURE_ARGS += --enable-dynamic
CONFIGURE_ARGS += --with-arch_h=$(WORK_DIR)/../../../cross/$(PKG_NAME)/src/config-arch/$(TC_ARCH)-arch.h

UNSUPPORTED_ARCHS += 88f6281 alpine armada370 armada375 armada38x armadaxp comcerto2k hi3535 ipq806x northstarplus rtd1296 armada37xx aarch64
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x qoriq
UNSUPPORTED_ARCHS += evansport
UNSUPPORTED_ARCHS += apollolake avoton broadwell broadwellnk bromolow cedarview denverton dockerx64 grantley kvmx64 x86 x64 x86_64 


include ../../mk/spksrc.cross-cc.mk
