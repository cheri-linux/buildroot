################################################################################
#
# openssh-cheri
#
################################################################################

OPENSSH_CHERI_VERSION = riscv-cheri-20220623
OPENSSH_CHERI_SITE = https://github.com/cheri-linux/openssh.git
OPENSSH_CHERI_SITE_METHOD = git

OPENSSH_CHERI_CONF_ENV = \
	CC="$(TARGET_CC_CLANG)" \
	LD="$(TARGET_CC_CLANG)" \
	LDFLAGS="$(TARGET_CFLAGS)" 
OPENSSH_CHERI_CONF_OPTS = \
	--prefix=/cheri/usr \
	--exec-prefix=/cheri/usr \
	--sysconfdir=/cheri/etc/ssh \
	--with-default-path=$(BR2_SYSTEM_DEFAULT_PATH) \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-strip \
	--with-cflags="-g"

define OPENSSH_CHERI_PERMISSIONS
	/var/empty d 755 root root - - - - -
endef

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
OPENSSH_CHERI_CONF_OPTS += --without-pie
endif

OPENSSH_CHERI_DEPENDENCIES = host-llvm-project musl-cheri host-pkgconf libzlib-cheri libopenssl-cheri

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
OPENSSH_CHERI_DEPENDENCIES += cryptodev-linux
OPENSSH_CHERI_CONF_OPTS += --with-ssl-engine
else
OPENSSH_CHERI_CONF_OPTS += --without-ssl-engine
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define OPENSSH_CHERI_INSTALL_PAM_CONF
	$(INSTALL) -D -m 644 $(@D)/contrib/sshd.pam.generic $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) '\%password   required     /lib/security/pam_cracklib.so%d' $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) 's/\#UsePAM no/UsePAM yes/' $(TARGET_DIR)/etc/ssh/sshd_config
endef

OPENSSH_CHERI_DEPENDENCIES += linux-pam
OPENSSH_CHERI_CONF_OPTS += --with-pam
OPENSSH_CHERI_POST_INSTALL_TARGET_HOOKS += OPENSSH_CHERI_INSTALL_PAM_CONF
else
OPENSSH_CHERI_CONF_OPTS += --without-pam
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
OPENSSH_CHERI_DEPENDENCIES += libselinux
OPENSSH_CHERI_CONF_OPTS += --with-selinux
else
OPENSSH_CHERI_CONF_OPTS += --without-selinux
endif

define OPENSSH_CHERI_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/openssh-cheri/S50sshd \
		$(TARGET_DIR)/etc/init.d/S50sshd-cheri
endef

define OPENSSH_CHERI_INSTALL_SSH_COPY_ID
	$(INSTALL) -D -m 755 $(@D)/contrib/ssh-copy-id $(TARGET_DIR)/cheri/usr/bin/ssh-copy-id
endef

OPENSSH_CHERI_POST_INSTALL_TARGET_HOOKS += OPENSSH_CHERI_INSTALL_SSH_COPY_ID

define OPENSSH_CHERI_UPDATE_CONFIG
	$(INSTALL) -D -m 0644 $(OPENSSH_CHERI_PKGDIR)/sshd_config.normal $(TARGET_DIR)/etc/ssh/sshd_config
	ssh-keygen -A -f $(TARGET_DIR)
	$(INSTALL) -D -m 0644 $(OPENSSH_CHERI_PKGDIR)/sshd_config.cheri $(TARGET_DIR)/cheri/etc/ssh/sshd_config
	ssh-keygen -A -f $(TARGET_DIR)/cheri
endef

OPENSSH_CHERI_TARGET_FINALIZE_HOOKS += OPENSSH_CHERI_UPDATE_CONFIG

$(eval $(autotools-package))
