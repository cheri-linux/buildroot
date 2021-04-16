################################################################################
#
# util-linux-libs-cheri
#
################################################################################

# Please keep this file as similar as possible to util-linux.mk

UTIL_LINUX_LIBS_CHERI_VERSION = $(UTIL_LINUX_CHERI_VERSION)
UTIL_LINUX_LIBS_CHERI_SOURCE = $(UTIL_LINUX_CHERI_SOURCE)
UTIL_LINUX_LIBS_CHERI_SITE = $(UTIL_LINUX_CHERI_SITE)
UTIL_LINUX_LIBS_CHERI_DL_SUBDIR = $(UTIL_LINUX_CHERI_DL_SUBDIR)

# README.licensing claims that some files are GPL-2.0 only, but this is not
# true. Some files are GPL-3.0+ but only in tests and optionally in hwclock
# (but we disable that option). rfkill uses an ISC-style license.
UTIL_LINUX_LIBS_CHERI_LICENSE = LGPL-2.1+ (libblkid, libfdisk, libmount), BSD-3-Clause (libuuid)
UTIL_LINUX_LIBS_CHERI_LICENSE_FILES = README.licensing \
	Documentation/licenses/COPYING.BSD-3-Clause \
	Documentation/licenses/COPYING.LGPL-2.1-or-later

UTIL_LINUX_LIBS_CHERI_INSTALL_STAGING = YES
UTIL_LINUX_LIBS_CHERI_DEPENDENCIES = \
	host-pkgconf \
	$(subst gettext,gettext-cheri,$(TARGET_NLS_DEPENDENCIES))
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += \
	--disable-rpath \
	--disable-makeinstall-chown \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr

UTIL_LINUX_LIBS_CHERI_CONF_ENV += \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_LD_CLANG)" \
	PKG_CONFIG_PATH=$(STAGING_DIR)/cheri/usr/lib/pkgconfig

UTIL_LINUX_LIBS_CHERI_LINK_LIBS = $(TARGET_NLS_LIBS)

# Prevent the installation from attempting to move shared libraries from
# ${usrlib_execdir} (/usr/lib) to ${libdir} (/lib), since both paths are
# the same when merged usr is in use.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --bindir=/cheri/usr/bin --sbindir=/cheri/usr/sbin --libdir=/cheri/usr/lib
endif

# systemd depends on util-linux-libs so we disable systemd support
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += \
	--without-systemd \
	--with-systemdsystemunitdir=no

# systemd/eudev depend on util-linux-libs so we disable udev support
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-udev

# No libs use wchar
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --disable-widechar

# No libs use ncurses
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-ncursesw --without-ncurses

# Unfortunately, the util-linux does LIBS="" at the end of its
# configure script. So we have to pass the proper LIBS value when
# calling the configure script to make configure tests pass properly,
# and then pass it again at build time.
UTIL_LINUX_LIBS_CHERI_CONF_ENV += LIBS="$(UTIL_LINUX_LIBS_CHERI_LINK_LIBS)"
UTIL_LINUX_LIBS_CHERI_MAKE_OPTS += LIBS="$(UTIL_LINUX_LIBS_CHERI_LINK_LIBS)"

# libmount optionally uses selinux
ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBMOUNT)$(BR2_PACKAGE_LIBSELINUX_CHERI),yy)
UTIL_LINUX_LIBS_CHERI_DEPENDENCIES += libselinux-cheri
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --with-selinux
else
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-selinux
endif

# Disable utilities
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += \
	--disable-all-programs \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBFDISK),--enable-libfdisk,--disable-libfdisk) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBSMARTCOLS),--enable-libsmartcols,--disable-libsmartcols) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBUUID),--enable-libuuid,--disable-libuuid)

# libmount python bindings are separate, will be installed by full util-linux
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-python --disable-pylibmount

# No libs use readline
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-readline

# No libs use audit
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-audit

# No libs use libmagic
UTIL_LINUX_LIBS_CHERI_CONF_OPTS += --without-libmagic

$(eval $(autotools-package))
