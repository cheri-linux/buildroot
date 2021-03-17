################################################################################
#
# dbus
#
################################################################################

#DBUS_CHERI_VERSION = 1.12.18
#DBUS_CHERI_SITE = https://dbus.freedesktop.org/releases/dbus
#DBUS_CHERI_SOURCE = dbus-$(DBUS_CHERI_VERSION).tar.gz
#DBUS_CHERI_VERSION = dbus-1.13.18
DBUS_CHERI_VERSION = riscv-cheri
DBUS_CHERI_SITE = https://github.com/cheri-linux/dbus.git
DBUS_CHERI_SITE_METHOD = git
DBUS_CHERI_LICENSE = AFL-2.1 or GPL-2.0+ (library, tools), GPL-2.0+ (tools)
DBUS_CHERI_LICENSE_FILES = COPYING
DBUS_CHERI_INSTALL_STAGING = YES

# Git version must be autoconf'd
#DBUS_CHERI_AUTORECONF = YES  # does not work properly
define DBUS_CHERI_PRE_CONFIGURE_BOOTSTRAP
    cd $(@D)/ && ./autogen.sh
endef
DBUS_CHERI_PRE_CONFIGURE_HOOKS += DBUS_CHERI_PRE_CONFIGURE_BOOTSTRAP

define DBUS_CHERI_PERMISSIONS
	/cheri/usr/libexec/dbus-daemon-launch-helper f 4750 0 dbus - - - - -
endef

define DBUS_CHERI_USERS
	dbus -1 dbus -1 * /run/dbus - dbus DBus messagebus user
endef

DBUS_CHERI_DEPENDENCIES = host-pkgconf expat-cheri

DBUS_CHERI_SELINUX_MODULES = dbus

DBUS_CHERI_CONF_ENV = \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_LD_CLANG)" \
	LDFLAGS="$(TARGET_CFLAGS)" \
	PKG_CONFIG_PATH=$(STAGING_DIR)/cheri/usr/lib/pkgconfig
DBUS_CHERI_CONF_OPTS = \
	--with-dbus-user=dbus \
	--disable-asserts \
	--disable-xml-docs \
	--disable-doxygen-docs \
	--with-system-socket=/run/dbus/system_bus_socket \
	--with-system-pid-file=/run/messagebus.pid \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr

define DBUS_CHERI_INSTALL_TESTS
	mkdir -p $(TARGET_DIR)/cheri/usr/bin/dbus-tests
	$(INSTALL) -m 755 $(@D)/test/.libs/test-dbus-daemon $(TARGET_DIR)/cheri/usr/bin/dbus-tests
endef

ifeq ($(BR2_PACKAGE_DBUS_CHERI_TESTS),y)
DBUS_CHERI_CONF_OPTS += \
	--enable-verbose-mode \
	--enable-debug=yes \
	--enable-embedded-tests \
	--enable-installed-tests \
	--enable-asserts
	#--enable-tests # this requires glib unfortunately...
#DBUS_CHERI_POST_INSTALL_TARGET_HOOKS += DBUS_CHERI_INSTALL_TESTS
else
DBUS_CHERI_CONF_OPTS += \
	--disable-tests
endif

#DBUS_CHERI_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR)/cheri install
#DBUS_CHERI_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR)/cheri install

ifeq ($(BR2_STATIC_LIBS),y)
DBUS_CHERI_CONF_OPTS += LIBS='-pthread'
endif

ifeq ($(BR2_microblaze),y)
# microblaze toolchain doesn't provide inotify_rm_* but does have sys/inotify.h
DBUS_CHERI_CONF_OPTS += --disable-inotify
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
DBUS_CHERI_CONF_OPTS += --enable-selinux
DBUS_CHERI_DEPENDENCIES += libselinux
else
DBUS_CHERI_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_AUDIT)$(BR2_PACKAGE_LIBCAP_NG),yy)
DBUS_CHERI_CONF_OPTS += --enable-libaudit
DBUS_CHERI_DEPENDENCIES += audit libcap-ng
else
DBUS_CHERI_CONF_OPTS += --disable-libaudit
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
DBUS_CHERI_CONF_OPTS += --with-x
DBUS_CHERI_DEPENDENCIES += xlib_libX11
ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
DBUS_CHERI_DEPENDENCIES += xlib_libSM
endif
else
DBUS_CHERI_CONF_OPTS += --without-x
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
DBUS_CHERI_CONF_OPTS += \
	--enable-systemd \
	--with-systemdsystemunitdir=/usr/lib/systemd/system
DBUS_CHERI_DEPENDENCIES += systemd
else
DBUS_CHERI_CONF_OPTS += --disable-systemd
endif

# fix rebuild (dbus makefile errors out if /var/lib/dbus is a symlink)
define DBUS_CHERI_REMOVE_VAR_LIB_DBUS
	rm -rf $(TARGET_DIR)/var/lib/dbus
endef

DBUS_CHERI_PRE_INSTALL_TARGET_HOOKS += DBUS_CHERI_REMOVE_VAR_LIB_DBUS

define DBUS_CHERI_REMOVE_DEVFILES
	rm -rf $(TARGET_DIR)/cheri/usr/lib/dbus-1.0
endef

DBUS_CHERI_POST_INSTALL_TARGET_HOOKS += DBUS_CHERI_REMOVE_DEVFILES

define DBUS_CHERI_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/dbus-cheri/S30dbus-cheri \
		$(TARGET_DIR)/etc/init.d/S30dbus-cheri

	mkdir -p $(TARGET_DIR)/var/lib
	rm -rf $(TARGET_DIR)/var/lib/dbus
	ln -sf /tmp/dbus $(TARGET_DIR)/var/lib/dbus
endef

define DBUS_CHERI_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/var/lib/dbus
	ln -sf /etc/machine-id $(TARGET_DIR)/var/lib/dbus/machine-id
endef

HOST_DBUS_CHERI_DEPENDENCIES = host-pkgconf host-expat
HOST_DBUS_CHERI_CONF_OPTS = \
	--with-dbus-user=dbus \
	--disable-tests \
	--disable-asserts \
	--disable-selinux \
	--disable-xml-docs \
	--disable-doxygen-docs \
	--disable-systemd \
	--without-x

# dbus for the host
DBUS_CHERI_HOST_INTROSPECT = $(HOST_DBUS_CHERI_DIR)/introspect.xml

HOST_DBUS_CHERI_GEN_INTROSPECT = \
	$(HOST_DIR)/bin/dbus-daemon --introspect > $(DBUS_CHERI_HOST_INTROSPECT)

HOST_DBUS_CHERI_POST_INSTALL_HOOKS += HOST_DBUS_CHERI_GEN_INTROSPECT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
