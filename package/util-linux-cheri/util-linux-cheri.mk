################################################################################
#
# util-linux-cheri
#
################################################################################

# When making changes to this file, please check if
# util-linux-libs/util-linux-libs.mk needs to be updated accordingly as well.

UTIL_LINUX_CHERI_VERSION_MAJOR = 2.36
UTIL_LINUX_CHERI_VERSION = $(UTIL_LINUX_CHERI_VERSION_MAJOR)
UTIL_LINUX_CHERI_SOURCE = util-linux-$(UTIL_LINUX_CHERI_VERSION).tar.xz
UTIL_LINUX_CHERI_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_CHERI_VERSION_MAJOR)

# README.licensing claims that some files are GPL-2.0 only, but this is not
# true. Some files are GPL-3.0+ but only in tests and optionally in hwclock
# (but we disable that option). rfkill uses an ISC-style license.
UTIL_LINUX_CHERI_LICENSE = GPL-2.0+, BSD-4-Clause, LGPL-2.1+ (libblkid, libfdisk, libmount), BSD-3-Clause (libuuid), ISC (rfkill)
UTIL_LINUX_CHERI_LICENSE_FILES = README.licensing \
	Documentation/licenses/COPYING.BSD-3-Clause \
	Documentation/licenses/COPYING.BSD-4-Clause-UC \
	Documentation/licenses/COPYING.GPL-2.0-or-later \
	Documentation/licenses/COPYING.ISC \
	Documentation/licenses/COPYING.LGPL-2.1-or-later

UTIL_LINUX_CHERI_INSTALL_STAGING = YES
UTIL_LINUX_CHERI_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBS_CHERI),util-linux-libs-cheri) \
	$(subst gettext,gettext-cheri,$(TARGET_NLS_DEPENDENCIES))
UTIL_LINUX_CHERI_CONF_OPTS += \
	--disable-rpath \
	--disable-makeinstall-chown \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr

UTIL_LINUX_CHERI_LINK_LIBS = $(TARGET_NLS_LIBS)

UTIL_LINUX_CHERI_CONF_ENV += \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_LD_CLANG)" \
	PKG_CONFIG_PATH=$(STAGING_DIR)/cheri/usr/lib/pkgconfig

HOST_UTIL_LINUX_CHERI_DEPENDENCIES = host-pkgconf

# We also don't want the host-python dependency
HOST_UTIL_LINUX_CHERI_CONF_OPTS = \
	--without-systemd \
	--with-systemdsystemunitdir=no \
	--without-python

ifneq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_BINARIES)$(BR2_PACKAGE_UTIL_LINUX_CHERI_CRAMFS)$(BR2_PACKAGE_UTIL_LINUX_CHERI_FSCK)$(BR2_PACKAGE_UTIL_LINUX_CHERI_LOSETUP),)
UTIL_LINUX_CHERI_SELINUX_MODULES = fstools
endif

# Prevent the installation from attempting to move shared libraries from
# ${usrlib_execdir} (/usr/lib) to ${libdir} (/lib), since both paths are
# the same when merged usr is in use.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
UTIL_LINUX_CHERI_CONF_OPTS += --bindir=/cheri/usr/bin --sbindir=/cheri/usr/sbin --libdir=/cheri/usr/lib
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-systemd --with-systemdsystemunitdir=/usr/lib/systemd/system
UTIL_LINUX_CHERI_DEPENDENCIES += systemd
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-systemd --with-systemdsystemunitdir=no
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-udev
UTIL_LINUX_CHERI_DEPENDENCIES += udev
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-udev
endif

ifeq ($(BR2_PACKAGE_NCURSES_CHERI),y)
UTIL_LINUX_CHERI_DEPENDENCIES += ncurses-cheri
ifeq ($(BR2_PACKAGE_NCURSES_CHERI_WCHAR),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-ncursesw
UTIL_LINUX_CHERI_CONF_ENV += NCURSESW6_CONFIG=$(STAGING_DIR)/cheri/usr/bin/$(NCURSES_CHERI_CONFIG_SCRIPTS)
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-ncursesw --with-ncurses --disable-widechar
UTIL_LINUX_CHERI_CONF_ENV += NCURSES6_CONFIG=$(STAGING_DIR)/cheri/usr/bin/$(NCURSES_CHERI_CONFIG_SCRIPTS)
endif
else
ifeq ($(BR2_USE_WCHAR),y)
UTIL_LINUX_CHERI_CONF_OPTS += --enable-widechar
else
UTIL_LINUX_CHERI_CONF_OPTS += --disable-widechar
endif
UTIL_LINUX_CHERI_CONF_OPTS += --without-ncursesw --without-ncurses
endif

# Unfortunately, the util-linux does LIBS="" at the end of its
# configure script. So we have to pass the proper LIBS value when
# calling the configure script to make configure tests pass properly,
# and then pass it again at build time.
UTIL_LINUX_CHERI_CONF_ENV += LIBS="$(UTIL_LINUX_CHERI_LINK_LIBS)"
UTIL_LINUX_CHERI_MAKE_OPTS += LIBS="$(UTIL_LINUX_CHERI_LINK_LIBS)"

ifeq ($(BR2_PACKAGE_LIBSELINUX_CHERI),y)
UTIL_LINUX_CHERI_DEPENDENCIES += libselinux-cheri
UTIL_LINUX_CHERI_CONF_OPTS += --with-selinux
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-selinux
define UTIL_LINUX_CHERI_SELINUX_PAMFILES_TWEAK
	$(foreach f,su su-l,
		$(SED) '/^.*pam_selinux.so.*$$/d' \
			$(TARGET_DIR)/etc/pam.d/$(f)
	)
endef
endif

# Used by setpriv
UTIL_LINUX_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBCAP_NG_CHERI),libcap-ng-cheri)

# Used by cramfs utils
UTIL_LINUX_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB_CHERI),zlib-cheri)

# Used by login-utils
UTIL_LINUX_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_LINUX_PAM_CHERI),linux-pam-cheri)

# Used by hardlink
UTIL_LINUX_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_PCRE2_CHERI),pcre2-cheri)

# Disable/Enable utilities
UTIL_LINUX_CHERI_CONF_OPTS += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_BINARIES),--enable-all-programs,--disable-all-programs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_AGETTY),--enable-agetty,--disable-agetty) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_BFS),--enable-bfs,--disable-bfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_CAL),--enable-cal,--disable-cal) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_CHFN_CHSH),--enable-chfn-chsh,--disable-chfn-chsh) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_CHMEM),--enable-chmem,--disable-chmem) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_CRAMFS),--enable-cramfs,--disable-cramfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_EJECT),--enable-eject,--disable-eject) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_FALLOCATE),--enable-fallocate,--disable-fallocate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_FDFORMAT),--enable-fdformat,--disable-fdformat) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_FSCK),--enable-fsck,--disable-fsck) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_HARDLINK),--enable-hardlink,--disable-hardlink) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_HWCLOCK),--enable-hwclock --disable-hwclock-gplv3,--disable-hwclock) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_IPCRM),--enable-ipcrm,--disable-ipcrm) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_IPCS),--enable-ipcs,--disable-ipcs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_KILL),--enable-kill,--disable-kill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LAST),--enable-last,--disable-last) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBFDISK),--enable-libfdisk,--disable-libfdisk) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBSMARTCOLS),--enable-libsmartcols,--disable-libsmartcols) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBUUID),--enable-libuuid,--disable-libuuid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LINE),--enable-line,--disable-line) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LOGGER),--enable-logger,--disable-logger) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LOGIN),--enable-login,--disable-login) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LOSETUP),--enable-losetup,--disable-losetup) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LSLOGINS),--enable-lslogins,--disable-lslogins) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_LSMEM),--enable-lsmem,--disable-lsmem) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_MESG),--enable-mesg,--disable-mesg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_MINIX),--enable-minix,--disable-minix) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_MORE),--enable-more,--disable-more) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_MOUNT),--enable-mount,--disable-mount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_MOUNTPOINT),--enable-mountpoint,--disable-mountpoint) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_NEWGRP),--enable-newgrp,--disable-newgrp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_NOLOGIN),--enable-nologin,--disable-nologin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_NSENTER),--enable-nsenter,--disable-nsenter) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_PARTX),--enable-partx,--disable-partx) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_PG),--enable-pg,--disable-pg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_PIVOT_ROOT),--enable-pivot_root,--disable-pivot_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_RAW),--enable-raw,--disable-raw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_RENAME),--enable-rename,--disable-rename) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_RFKILL),--enable-rfkill,--disable-rfkill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_RUNUSER),--enable-runuser,--disable-runuser) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SCHEDUTILS),--enable-schedutils,--disable-schedutils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SETPRIV),--enable-setpriv,--disable-setpriv) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SETTERM),--enable-setterm,--disable-setterm) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SU),--enable-su,--disable-su) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SULOGIN),--enable-sulogin,--disable-sulogin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_SWITCH_ROOT),--enable-switch_root,--disable-switch_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_TUNELP),--enable-tunelp,--disable-tunelp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_UL),--enable-ul,--disable-ul) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_UNSHARE),--enable-unshare,--disable-unshare) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_UTMPDUMP),--enable-utmpdump,--disable-utmpdump) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_UUIDD),--enable-uuidd,--disable-uuidd) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_VIPW),--enable-vipw,--disable-vipw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_WALL),--enable-wall,--disable-wall) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_WDCTL),--enable-wdctl,--disable-wdctl) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_WIPEFS),--enable-wipefs,--disable-wipefs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_WRITE),--enable-write,--disable-write) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHERI_ZRAMCTL),--enable-zramctl,--disable-zramctl)

# In the host version of util-linux, we only require libuuid and
# libmount (plus libblkid as an indirect dependency of libmount).
# So disable all of the programs, unless BR2_PACKAGE_HOST_UTIL_LINUX is set

HOST_UTIL_LINUX_CHERI_CONF_OPTS += \
	--enable-libblkid \
	--enable-libmount \
	--enable-libuuid \
	--without-libmagic \
	--without-ncurses \
	--without-ncursesw \
	--without-tinfo

ifeq ($(BR2_PACKAGE_HOST_UTIL_LINUX_CHERI),y)
HOST_UTIL_LINUX_CHERI_CONF_OPTS += --disable-makeinstall-chown
# disable commands that have ncurses dependency, as well as
# other ones that are useless on the host
HOST_UTIL_LINUX_CHERI_CONF_OPTS += \
	--disable-agetty \
	--disable-chfn-chsh \
	--disable-chmem \
	--disable-login \
	--disable-lslogins \
	--disable-mesg \
	--disable-more \
	--disable-newgrp \
	--disable-nologin \
	--disable-nsenter \
	--disable-pg \
	--disable-rfkill \
	--disable-schedutils \
	--disable-setpriv \
	--disable-setterm \
	--disable-su \
	--disable-sulogin \
	--disable-tunelp \
	--disable-ul \
	--disable-unshare \
	--disable-uuidd \
	--disable-vipw \
	--disable-wall \
	--disable-wdctl \
	--disable-write \
	--disable-zramctl
# Used by cramfs utils
HOST_UTIL_LINUX_CHERI_DEPENDENCIES += host-zlib
else
HOST_UTIL_LINUX_CHERI_CONF_OPTS += --disable-all-programs
endif

# Install libmount Python bindings
ifeq ($(BR2_PACKAGE_PYTHON_CHERI)$(BR2_PACKAGE_PYTHON3_CHERI),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-python
UTIL_LINUX_CHERI_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON_CHERI),python-cheri,python3-cheri)
ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBMOUNT),y)
UTIL_LINUX_CHERI_CONF_OPTS += --enable-pylibmount
else
UTIL_LINUX_CHERI_CONF_OPTS += --disable-pylibmount
endif
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-python
endif

ifeq ($(BR2_PACKAGE_READLINE_CHERI),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-readline
UTIL_LINUX_CHERI_LINK_LIBS += $(if $(BR2_STATIC_LIBS),-lcurses)
UTIL_LINUX_CHERI_DEPENDENCIES += readline-cheri
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_AUDIT_CHERI),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-audit
UTIL_LINUX_CHERI_DEPENDENCIES += audit-cheri
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-audit
endif

ifeq ($(BR2_PACKAGE_FILE_CHERI),y)
UTIL_LINUX_CHERI_CONF_OPTS += --with-libmagic
UTIL_LINUX_CHERI_DEPENDENCIES += file-cheri
else
UTIL_LINUX_CHERI_CONF_OPTS += --without-libmagic
endif

# Install PAM configuration files
ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_SU)$(BR2_PACKAGE_LINUX_PAM_CHERI),yy)
define UTIL_LINUX_CHERI_INSTALL_PAMFILES
	$(INSTALL) -D -m 0644 package/util-linux-cheri/su.pam \
		$(TARGET_DIR)/etc/pam.d/su
	$(INSTALL) -D -m 0644 package/util-linux-cheri/su.pam \
		$(TARGET_DIR)/etc/pam.d/su-l
	$(UTIL_LINUX_CHERI_SELINUX_PAMFILES_TWEAK)
endef
UTIL_LINUX_CHERI_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_CHERI_INSTALL_PAMFILES
endif

# Install agetty->getty symlink to avoid breakage when there's no busybox
ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_AGETTY),y)
ifeq ($(BR2_PACKAGE_BUSYBOX_CHERI),)
define UTIL_LINUX_CHERI_GETTY_SYMLINK
	ln -sf agetty $(TARGET_DIR)/sbin/getty
endef
endif
endif

UTIL_LINUX_CHERI_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_CHERI_GETTY_SYMLINK

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# Must be included after the autotools-package call, to make sure all variables
# are available
include package/util-linux-cheri/util-linux-libs-cheri/util-linux-libs-cheri.mk
