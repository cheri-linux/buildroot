################################################################################
#
# kmod
#
################################################################################

KMOD_CHERI_VERSION = 27
KMOD_CHERI_SOURCE = kmod-$(KMOD_CHERI_VERSION).tar.xz
KMOD_CHERI_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/kmod
KMOD_CHERI_INSTALL_STAGING = YES
KMOD_CHERI_DEPENDENCIES = host-pkgconf
#HOST_KMOD_CHERI_DEPENDENCIES = host-pkgconf

# license info for libkmod only, conditionally add more below
KMOD_CHERI_LICENSE = LGPL-2.1+ (library)
KMOD_CHERI_LICENSE_FILES = libkmod/COPYING

# --gc-sections triggers binutils ld segfault
# https://sourceware.org/bugzilla/show_bug.cgi?id=21180
ifeq ($(BR2_microblaze),y)
KMOD_CHERI_CONF_ENV += cc_cv_LDFLAGS__Wl___gc_sections=false
endif

# static linking not supported, see
# https://git.kernel.org/cgit/utils/kernel/kmod/kmod.git/commit/?id=b7016153ec8
KMOD_CHERI_CONF_OPTS = --disable-static --enable-shared

# CHERI
KMOD_CHERI_CONF_ENV += \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_LD_CLANG)"

KMOD_CHERI_CONF_OPTS += \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr


KMOD_CHERI_CONF_OPTS += --disable-manpages
#HOST_KMOD_CHERI_CONF_OPTS = --disable-manpages

ifeq ($(BR2_PACKAGE_BASH_COMPLETION),y)
KMOD_CHERI_CONF_OPTS += --with-bashcompletiondir=/usr/share/bash-completion/completions
endif

ifeq ($(BR2_PACKAGE_ZLIB_CHERI),y)
KMOD_CHERI_DEPENDENCIES += zlib-cheri
KMOD_CHERI_CONF_OPTS += --with-zlib
else
KMOD_CHERI_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_XZ_CHERI),y)
KMOD_CHERI_DEPENDENCIES += xz-cheri
KMOD_CHERI_CONF_OPTS += --with-xz
else
KMOD_CHERI_CONF_OPTS += --without-xz
endif

ifeq ($(BR2_PACKAGE_OPENSSL_CHERI),y)
KMOD_CHERI_DEPENDENCIES += openssl-cheri
KMOD_CHERI_CONF_OPTS += --with-openssl
else
KMOD_CHERI_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_PYTHON_CHERI)$(BR2_PACKAGE_PYTHON3_CHERI),y)
KMOD_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON_CHERI),python-cheri,python3-cheri)
KMOD_CHERI_CONF_OPTS += --enable-python
endif

ifeq ($(BR2_PACKAGE_KMOD_CHERI_TOOLS),y)

# add license info for kmod tools
KMOD_CHERI_LICENSE += , GPL-2.0+ (tools)
KMOD_CHERI_LICENSE_FILES += COPYING

# CHERI: the /cheri prefix does not support a merged usr setup

# /sbin is really /usr/sbin with merged /usr, so adjust relative symlink
# ifeq ($(BR2_ROOTFS_MERGED_USR),y)
# KMOD_CHERI_BIN_PATH = ../bin/kmod
# else
# KMOD_CHERI_BIN_PATH = ../usr/bin/kmod
# endif

define KMOD_CHERI_INSTALL_TOOLS
	for i in depmod insmod lsmod modinfo modprobe rmmod; do \
		ln -sf ../usr/bin/kmod $(TARGET_DIR)/cheri/sbin/$$i; \
	done
endef

KMOD_CHERI_POST_INSTALL_TARGET_HOOKS += KMOD_CHERI_INSTALL_TOOLS
else
KMOD_CHERI_CONF_OPTS += --disable-tools
endif

#ifeq ($(BR2_PACKAGE_HOST_KMOD_CHERI_GZ),y)
#HOST_KMOD_CHERI_DEPENDENCIES += host-zlib
#HOST_KMOD_CHERI_CONF_OPTS += --with-zlib
#else
#HOST_KMOD_CHERI_CONF_OPTS += --without-zlib
#endif
#
#ifeq ($(BR2_PACKAGE_HOST_KMOD_CHERI_XZ),y)
#HOST_KMOD_CHERI_DEPENDENCIES += host-xz
#HOST_KMOD_CHERI_CONF_OPTS += --with-xz
#else
#HOST_KMOD_CHERI_CONF_OPTS += --without-xz
#endif
#
## We only install depmod, since that's the only tool used for the
## host.
#define HOST_KMOD_CHERI_INSTALL_TOOLS
#	mkdir -p $(HOST_DIR)/sbin/
#	ln -sf ../bin/kmod $(HOST_DIR)/sbin/depmod
#endef
#
#HOST_KMOD_CHERI_POST_INSTALL_HOOKS += HOST_KMOD_CHERI_INSTALL_TOOLS

$(eval $(autotools-package))
#$(eval $(host-autotools-package))
