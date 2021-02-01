################################################################################
#
# libzlib-cheri
#
################################################################################

LIBZLIB_CHERI_VERSION = 1.2.11
LIBZLIB_CHERI_SOURCE = zlib-$(LIBZLIB_CHERI_VERSION).tar.xz
LIBZLIB_CHERI_SITE = http://www.zlib.net
LIBZLIB_CHERI_LICENSE = Zlib
LIBZLIB_CHERI_LICENSE_FILES = README
LIBZLIB_CHERI_INSTALL_STAGING = YES

# It is not possible to build only a shared version of zlib, so we build both
# shared and static, unless we only want the static libs, and we eventually
# selectively remove what we do not want
ifeq ($(BR2_STATIC_LIBS),y)
LIBZLIB_CHERI_PIC =
LIBZLIB_CHERI_SHARED = --static
else
LIBZLIB_CHERI_PIC = -fPIC
LIBZLIB_CHERI_SHARED = --shared
endif

define LIBZLIB_CHERI_CONFIGURE_CMDS
	(cd $(@D); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(LIBZLIB_CHERI_PIC)" \
		CC=$(TARGET_CC_CLANG) \
		./configure \
		$(LIBZLIB_CHERI_SHARED) \
		--prefix=/cheri/usr \
	)
endef

define LIBZLIB_CHERI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define LIBZLIB_CHERI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(STAGING_DIR) LDCONFIG=true install
endef

define LIBZLIB_CHERI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) LDCONFIG=true install
endef

# We don't care removing the .a from target, since it not used at link
# time to build other packages, and it is anyway removed later before
# assembling the filesystem images anyway.
ifeq ($(BR2_SHARED_LIBS),y)
define LIBZLIB_CHERI_RM_STATIC_STAGING
	rm -f $(STAGING_DIR)/usr/lib/libz.a
endef
LIBZLIB_CHERI_POST_INSTALL_STAGING_HOOKS += LIBZLIB_CHERI_RM_STATIC_STAGING
endif

$(eval $(generic-package))
