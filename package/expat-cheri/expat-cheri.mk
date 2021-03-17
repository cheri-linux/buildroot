################################################################################
#
# expat
#
################################################################################

EXPAT_CHERI_VERSION = 2.2.10
EXPAT_CHERI_SITE = http://downloads.sourceforge.net/project/expat/expat/$(EXPAT_CHERI_VERSION)
EXPAT_CHERI_SOURCE = expat-$(EXPAT_CHERI_VERSION).tar.xz
EXPAT_CHERI_INSTALL_STAGING = YES
EXPAT_CHERI_DEPENDENCIES = host-pkgconf
HOST_EXPAT_CHERI_DEPENDENCIES = host-pkgconf
EXPAT_CHERI_LICENSE = MIT
EXPAT_CHERI_LICENSE_FILES = COPYING

EXPAT_CHERI_CONF_OPTS = --without-docbook
HOST_EXPAT_CHERI_CONF_OPTS = --without-docbook

EXPAT_CHERI_CONF_ENV = \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_CC_CLANG)" \
	LDFLAGS="$(TARGET_CFLAGS)"
EXPAT_CHERI_CONF_OPTS = \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr

$(eval $(autotools-package))
$(eval $(host-autotools-package))
