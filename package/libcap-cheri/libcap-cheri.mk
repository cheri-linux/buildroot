################################################################################
#
# libcap-cheri
#
################################################################################

LIBCAP_CHERI_VERSION = 2.45
LIBCAP_CHERI_SITE = https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_CHERI_SOURCE = libcap-$(LIBCAP_CHERI_VERSION).tar.xz
LIBCAP_CHERI_LICENSE = GPL-2.0 or BSD-3-Clause
LIBCAP_CHERI_LICENSE_FILES = License

LIBCAP_CHERI_DEPENDENCIES = host-libcap host-gperf
LIBCAP_CHERI_INSTALL_STAGING = YES

#HOST_LIBCAP_CHERI_DEPENDENCIES = host-gperf

LIBCAP_CHERI_MAKE_FLAGS = \
	CC="$(TARGET_CC_CLANG)" \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	SHARED=$(if $(BR2_STATIC_LIBS),,yes) \
	PTHREADS=$(if $(BR2_TOOLCHAIN_HAS_THREADS),yes,)

LIBCAP_CHERI_MAKE_DIRS = libcap

ifeq ($(BR2_PACKAGE_LIBCAP_CHERI_TOOLS),y)
LIBCAP_CHERI_MAKE_DIRS += progs
endif

define LIBCAP_CHERI_BUILD_CMDS
	$(foreach d,$(LIBCAP_CHERI_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$(d) \
			$(LIBCAP_CHERI_MAKE_FLAGS) prefix=/cheri/usr all
	)
endef

define LIBCAP_CHERI_INSTALL_STAGING_CMDS
	$(foreach d,$(LIBCAP_CHERI_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(d) $(LIBCAP_CHERI_MAKE_FLAGS) \
			DESTDIR=$(STAGING_DIR) prefix=/cheri/usr lib=lib install
	)
endef

define LIBCAP_CHERI_INSTALL_TARGET_CMDS
	$(foreach d,$(LIBCAP_CHERI_MAKE_DIRS), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/$(d) $(LIBCAP_CHERI_MAKE_FLAGS) \
			DESTDIR=$(TARGET_DIR) prefix=/cheri/usr lib=lib install
	)
endef

#define HOST_LIBCAP_CHERI_BUILD_CMDS
#	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)\
#		DYNAMIC=yes \
#		RAISE_SETFCAP=no GOLANG=no
#endef

#define HOST_LIBCAP_CHERI_INSTALL_CMDS
#	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) prefix=$(HOST_DIR) \
#		DYNAMIC=yes \
#		RAISE_SETFCAP=no GOLANG=no lib=lib install
#endef

$(eval $(generic-package))
#$(eval $(host-generic-package))
