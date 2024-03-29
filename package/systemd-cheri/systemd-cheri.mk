################################################################################
#
# systemd
#
################################################################################

SYSTEMD_CHERI_VERSION = riscv-cheri
SYSTEMD_CHERI_SITE = https://github.com/cheri-linux/systemd.git
SYSTEMD_CHERI_SITE_METHOD = git
SYSTEMD_CHERI_LICENSE = LGPL-2.1+, GPL-2.0+ (udev), Public Domain (few source files, see README), BSD-3-Clause (tools/chromiumos)
SYSTEMD_CHERI_LICENSE_FILES = LICENSE.GPL2 LICENSE.LGPL2.1 README tools/chromiumos/LICENSE
SYSTEMD_CHERI_INSTALL_STAGING = YES
SYSTEMD_CHERI_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	$(if $(BR2_PACKAGE_BASH_COMPLETION),bash-completion) \
	host-gperf \
	kmod-cheri \
	libcap-cheri \
	util-linux-libs-cheri \
	$(TARGET_NLS_DEPENDENCIES)

SYSTEMD_CHERI_NOPREFIX_CLANG = YES

SYSTEMD_CHERI_SELINUX_MODULES = systemd udev

SYSTEMD_CHERI_PROVIDES = udev

SYSTEMD_CHERI_CONF_OPTS += \
	-Ddefault-hierarchy=hybrid \
	-Didn=true \
	-Dima=false \
	-Dkexec-path=/cheri/usr/sbin/kexec \
	-Dkmod-path=/cheri/usr/bin/kmod \
	-Dldconfig=false \
	-Dloadkeys-path=/cheri/usr/bin/loadkeys \
	-Dman=false \
	-Dmount-path=/cheri/usr/bin/mount \
	-Dnss-systemd=true \
	-Dportabled=false \
	-Dquotacheck-path=/usr/sbin/quotacheck \
	-Dquotaon-path=/usr/sbin/quotaon \
	-Drootlibdir='/usr/lib' \
	-Dsetfont-path=/cheri/usr/bin/setfont \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	-Dsulogin-path=/cheri/sbin/sulogin \
	-Dsystem-gid-max=999 \
	-Dsystem-uid-max=999 \
	-Dsysvinit-path= \
	-Dsysvrcnd-path= \
	-Dtelinit-path= \
	-Dtests=false \
	-Dumount-path=/cheri/usr/bin/umount \
	-Dutmp=false \
	-Drootprefix=/usr

ifeq ($(BR2_PACKAGE_ACL_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += acl-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dacl=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dacl=false
endif

ifeq ($(BR2_PACKAGE_LIBAPPARMOR_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libapparmor-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dapparmor=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dapparmor=false
endif

ifeq ($(BR2_PACKAGE_AUDIT_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += audit-cheri
SYSTEMD_CHERI_CONF_OPTS += -Daudit=true
else
SYSTEMD_CHERI_CONF_OPTS += -Daudit=false
endif

ifeq ($(BR2_PACKAGE_CRYPTSETUP_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += cryptsetup-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlibcryptsetup=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlibcryptsetup=false
endif

ifeq ($(BR2_PACKAGE_ELFUTILS_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += elfutils-cheri
SYSTEMD_CHERI_CONF_OPTS += -Delfutils=true
else
SYSTEMD_CHERI_CONF_OPTS += -Delfutils=false
endif

ifeq ($(BR2_PACKAGE_GNUTLS_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += gnutls-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dgnutls=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dgnutls=false
endif

ifeq ($(BR2_PACKAGE_IPTABLES_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += iptables-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlibiptc=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlibiptc=false
endif

# Both options can't be selected at the same time so prefer libidn2
ifeq ($(BR2_PACKAGE_LIBIDN2_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libidn2-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlibidn2=true -Dlibidn=false
else ifeq ($(BR2_PACKAGE_LIBIDN_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libidn-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlibidn=true -Dlibidn2=false
else
SYSTEMD_CHERI_CONF_OPTS += -Dlibidn=false -Dlibidn2=false
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libseccomp-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dseccomp=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dseccomp=false
endif

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libxkbcommon-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dxkbcommon=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dxkbcommon=false
endif

ifeq ($(BR2_PACKAGE_BZIP2_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += bzip2-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dbzip2=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dbzip2=false
endif

ifeq ($(BR2_PACKAGE_ZSTD_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += zstd-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dzstd=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dzstd=false
endif

ifeq ($(BR2_PACKAGE_LZ4_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += lz4-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlz4=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlz4=false
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += linux-pam-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dpam=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dpam=false
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBFDISK),y)
SYSTEMD_CHERI_CONF_OPTS += -Dfdisk=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dfdisk=false
endif

ifeq ($(BR2_PACKAGE_VALGRIND_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += valgrind-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dvalgrind=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dvalgrind=false
endif

ifeq ($(BR2_PACKAGE_XZ_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += xz-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dxz=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dxz=false
endif

ifeq ($(BR2_PACKAGE_ZLIB_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += zlib-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dzlib=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dzlib=false
endif

ifeq ($(BR2_PACKAGE_LIBCURL_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libcurl-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dlibcurl=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlibcurl=false
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libgcrypt-cheri
SYSTEMD_CHERI_CONF_OPTS += -Ddefault-dnssec=allow-downgrade -Dgcrypt=true
else
SYSTEMD_CHERI_CONF_OPTS += -Ddefault-dnssec=no -Dgcrypt=false
endif

ifeq ($(BR2_PACKAGE_P11_KIT_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += p11-kit-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dp11kit=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dp11kit=false
endif

ifeq ($(BR2_PACKAGE_OPENSSL_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += openssl-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dopenssl=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dopenssl=false
endif

ifeq ($(BR2_PACKAGE_PCRE2_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += pcre2-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dpcre2=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dpcre2=false
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_LIBBLKID),y)
SYSTEMD_CHERI_CONF_OPTS += -Dblkid=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dblkid=false
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_CHERI_NOLOGIN),y)
SYSTEMD_CHERI_CONF_OPTS += -Dnologin-path=/cheri/usr/sbin/nologin
else
SYSTEMD_CHERI_CONF_OPTS += -Dnologin-path=/cheri/bin/false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_INITRD),y)
SYSTEMD_CHERI_CONF_OPTS += -Dinitrd=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dinitrd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_KERNELINSTALL),y)
SYSTEMD_CHERI_CONF_OPTS += -Dkernel-install=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dkernel-install=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_ANALYZE),y)
SYSTEMD_CHERI_CONF_OPTS += -Danalyze=true
else
SYSTEMD_CHERI_CONF_OPTS += -Danalyze=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_JOURNAL_REMOTE),y)
# remote also depends on libcurl, this is already added above.
SYSTEMD_CHERI_DEPENDENCIES += libmicrohttpd-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dremote=true -Dmicrohttpd=true
SYSTEMD_CHERI_REMOTE_USER = systemd-journal-remote -1 systemd-journal-remote -1 * - - - systemd Journal Remote
else
SYSTEMD_CHERI_CONF_OPTS += -Dremote=false -Dmicrohttpd=false
endif

ifeq ($(BR2_PACKAGE_LIBQRENCODE_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libqrencode-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dqrencode=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dqrencode=false
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX_CHERI),y)
SYSTEMD_CHERI_DEPENDENCIES += libselinux-cheri
SYSTEMD_CHERI_CONF_OPTS += -Dselinux=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dselinux=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_HWDB),y)
SYSTEMD_CHERI_CONF_OPTS += -Dhwdb=true
define SYSTEMD_CHERI_BUILD_HWDB
	$(HOST_DIR)/bin/udevadm hwdb --update --root $(TARGET_DIR)
endef
SYSTEMD_CHERI_TARGET_FINALIZE_HOOKS += SYSTEMD_CHERI_BUILD_HWDB
define SYSTEMD_CHERI_RM_HWDB_SRV
	rm -rf $(TARGET_DIR)/$(HOST_EUDEV_SYSCONFDIR)/udev/hwdb.d/
endef
SYSTEMD_CHERI_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_CHERI_RM_HWDB_SRV
else
SYSTEMD_CHERI_CONF_OPTS += -Dhwdb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_BINFMT),y)
SYSTEMD_CHERI_CONF_OPTS += -Dbinfmt=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dbinfmt=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_VCONSOLE),y)
SYSTEMD_CHERI_CONF_OPTS += -Dvconsole=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dvconsole=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_QUOTACHECK),y)
SYSTEMD_CHERI_CONF_OPTS += -Dquotacheck=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dquotacheck=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_TMPFILES),y)
SYSTEMD_CHERI_CONF_OPTS += -Dtmpfiles=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dtmpfiles=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_SYSUSERS),y)
SYSTEMD_CHERI_CONF_OPTS += -Dsysusers=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dsysusers=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_FIRSTBOOT),y)
SYSTEMD_CHERI_CONF_OPTS += -Dfirstboot=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dfirstboot=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_RANDOMSEED),y)
SYSTEMD_CHERI_CONF_OPTS += -Drandomseed=true
else
SYSTEMD_CHERI_CONF_OPTS += -Drandomseed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_BACKLIGHT),y)
SYSTEMD_CHERI_CONF_OPTS += -Dbacklight=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dbacklight=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_RFKILL),y)
SYSTEMD_CHERI_CONF_OPTS += -Drfkill=true
else
SYSTEMD_CHERI_CONF_OPTS += -Drfkill=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_LOGIND),y)
SYSTEMD_CHERI_CONF_OPTS += -Dlogind=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlogind=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_MACHINED),y)
SYSTEMD_CHERI_CONF_OPTS += -Dmachined=true -Dnss-mymachines=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dmachined=false -Dnss-mymachines=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_IMPORTD),y)
SYSTEMD_CHERI_CONF_OPTS += -Dimportd=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dimportd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_HOMED),y)
SYSTEMD_CHERI_CONF_OPTS += -Dhomed=true
SYSTEMD_CHERI_DEPENDENCIES += cryptsetup-cheri openssl-cheri
else
SYSTEMD_CHERI_CONF_OPTS += -Dhomed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_HOSTNAMED),y)
SYSTEMD_CHERI_CONF_OPTS += -Dhostnamed=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dhostnamed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_MYHOSTNAME),y)
SYSTEMD_CHERI_CONF_OPTS += -Dnss-myhostname=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dnss-myhostname=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_TIMEDATED),y)
SYSTEMD_CHERI_CONF_OPTS += -Dtimedated=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dtimedated=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_LOCALED),y)
SYSTEMD_CHERI_CONF_OPTS += -Dlocaled=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dlocaled=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_REPART),y)
SYSTEMD_CHERI_CONF_OPTS += -Drepart=true
SYSTEMD_CHERI_DEPENDENCIES += openssl-cheri
else
SYSTEMD_CHERI_CONF_OPTS += -Drepart=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_USERDB),y)
SYSTEMD_CHERI_CONF_OPTS += -Duserdb=true
else
SYSTEMD_CHERI_CONF_OPTS += -Duserdb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_COREDUMP),y)
SYSTEMD_CHERI_CONF_OPTS += -Dcoredump=true
SYSTEMD_CHERI_COREDUMP_USER = systemd-coredump -1 systemd-coredump -1 * - - - systemd core dump processing
else
SYSTEMD_CHERI_CONF_OPTS += -Dcoredump=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_PSTORE),y)
SYSTEMD_CHERI_CONF_OPTS += -Dpstore=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dpstore=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_POLKIT),y)
SYSTEMD_CHERI_CONF_OPTS += -Dpolkit=true
SYSTEMD_CHERI_DEPENDENCIES += polkit-cheri
else
SYSTEMD_CHERI_CONF_OPTS += -Dpolkit=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_NETWORKD),y)
SYSTEMD_CHERI_CONF_OPTS += -Dnetworkd=true
SYSTEMD_CHERI_NETWORKD_USER = systemd-network -1 systemd-network -1 * - - - systemd Network Management
SYSTEMD_CHERI_NETWORKD_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))
ifneq ($(SYSTEMD_CHERI_NETWORKD_DHCP_IFACE),)
define SYSTEMD_CHERI_INSTALL_NETWORK_CONFS
	sed s/SYSTEMD_NETWORKD_DHCP_IFACE/$(SYSTEMD_CHERI_NETWORKD_DHCP_IFACE)/ \
		$(SYSTEMD_CHERI_PKGDIR)/dhcp.network > \
		$(TARGET_DIR)/etc/systemd/network/$(SYSTEMD_CHERI_NETWORKD_DHCP_IFACE).network
endef
endif
else
SYSTEMD_CHERI_CONF_OPTS += -Dnetworkd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_RESOLVED),y)
define SYSTEMD_CHERI_INSTALL_RESOLVCONF_HOOK
	ln -sf ../run/systemd/resolve/resolv.conf \
		$(TARGET_DIR)/etc/resolv.conf
endef
SYSTEMD_CHERI_CONF_OPTS += -Dnss-resolve=true -Dresolve=true
SYSTEMD_CHERI_RESOLVED_USER = systemd-resolve -1 systemd-resolve -1 * - - - systemd Resolver
else
SYSTEMD_CHERI_CONF_OPTS += -Dnss-resolve=false -Dresolve=false
endif

ifeq ($(BR2_PACKAGE_GNUTLS_CHERI),y)
SYSTEMD_CHERI_CONF_OPTS += -Ddns-over-tls=gnutls -Ddefault-dns-over-tls=opportunistic
SYSTEMD_CHERI_DEPENDENCIES += gnutls-cheri
else ifeq ($(BR2_PACKAGE_OPENSSL_CHERI),y)
SYSTEMD_CHERI_CONF_OPTS += -Ddns-over-tls=openssl -Ddefault-dns-over-tls=opportunistic
SYSTEMD_CHERI_DEPENDENCIES += openssl-cheri
else
SYSTEMD_CHERI_CONF_OPTS += -Ddns-over-tls=false -Ddefault-dns-over-tls=no
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_TIMESYNCD),y)
SYSTEMD_CHERI_CONF_OPTS += -Dtimesyncd=true
SYSTEMD_CHERI_TIMESYNCD_USER = systemd-timesync -1 systemd-timesync -1 * - - - systemd Time Synchronization
else
SYSTEMD_CHERI_CONF_OPTS += -Dtimesyncd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_SMACK_SUPPORT),y)
SYSTEMD_CHERI_CONF_OPTS += -Dsmack=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dsmack=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_HIBERNATE),y)
SYSTEMD_CHERI_CONF_OPTS += -Dhibernate=true
else
SYSTEMD_CHERI_CONF_OPTS += -Dhibernate=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CHERI_BOOT),y)
SYSTEMD_CHERI_INSTALL_IMAGES = YES
SYSTEMD_CHERI_DEPENDENCIES += gnu-efi-cheri
SYSTEMD_CHERI_CONF_OPTS += \
	-Defi=true \
	-Dgnu-efi=true \
	-Defi-cc=$(TARGET_CC) \
	-Defi-ld=$(TARGET_LD) \
	-Defi-libdir=$(STAGING_DIR)/usr/lib \
	-Defi-ldsdir=$(STAGING_DIR)/usr/lib \
	-Defi-includedir=$(STAGING_DIR)/usr/include/efi

SYSTEMD_CHERI_BOOT_EFI_ARCH = $(call qstrip,$(BR2_PACKAGE_SYSTEMD_CHERI_BOOT_EFI_ARCH))
define SYSTEMD_CHERI_INSTALL_BOOT_FILES
	$(INSTALL) -D -m 0644 $(@D)/build/src/boot/efi/systemd-boot$(SYSTEMD_CHERI_BOOT_EFI_ARCH).efi \
		$(BINARIES_DIR)/efi-part/EFI/BOOT/boot$(SYSTEMD_CHERI_BOOT_EFI_ARCH).efi
	echo "boot$(SYSTEMD_CHERI_BOOT_EFI_ARCH).efi" > \
		$(BINARIES_DIR)/efi-part/startup.nsh
	$(INSTALL) -D -m 0644 $(SYSTEMD_CHERI_PKGDIR)/boot-files/loader.conf \
		$(BINARIES_DIR)/efi-part/loader/loader.conf
	$(INSTALL) -D -m 0644 $(SYSTEMD_CHERI_PKGDIR)/boot-files/buildroot.conf \
		$(BINARIES_DIR)/efi-part/loader/entries/buildroot.conf
endef

else
SYSTEMD_CHERI_CONF_OPTS += -Defi=false -Dgnu-efi=false
endif # BR2_PACKAGE_SYSTEMD_CHERI_BOOT == y

SYSTEMD_CHERI_FALLBACK_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
ifneq ($(SYSTEMD_CHERI_FALLBACK_HOSTNAME),)
SYSTEMD_CHERI_CONF_OPTS += -Dfallback-hostname=$(SYSTEMD_CHERI_FALLBACK_HOSTNAME)
endif

define SYSTEMD_CHERI_LINK_LIBs
	$(HOSTLN) -snf ../../../usr/lib/libudev.so.1.6.18 $(STAGING_DIR)/cheri/usr/lib/libudev.so.1.6.18
	$(HOSTLN) -snf libudev.so.1.6.18 $(STAGING_DIR)/cheri/usr/lib/libudev.so.1
	$(HOSTLN) -snf libudev.so.1 $(STAGING_DIR)/cheri/usr/lib/libudev.so
	$(HOSTLN) -snf ../../../usr/lib/libsystemd.so.0.29.0 $(STAGING_DIR)/cheri/usr/lib/libsystemd.so.0.29.0
	$(HOSTLN) -snf libsystemd.so.0.29.0 $(STAGING_DIR)/cheri/usr/lib/libsystemd.so.0
	$(HOSTLN) -snf libsystemd.so.0 $(STAGING_DIR)/cheri/usr/lib/libsystemd.so
	sed -e 's%libdir=/usr/lib%libdir=/cheri/usr/lib%g' \
	    $(STAGING_DIR)/usr/lib/pkgconfig/libsystemd.pc \
		> $(STAGING_DIR)/cheri/usr/lib/pkgconfig/libsystemd.pc
endef

SYSTEMD_CHERI_POST_INSTALL_STAGING_HOOKS += SYSTEMD_CHERI_LINK_LIBs

define SYSTEMD_CHERI_INSTALL_INIT_HOOK
	ln -fs multi-user.target \
		$(TARGET_DIR)/usr/lib/systemd/system/default.target
endef

define SYSTEMD_CHERI_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

SYSTEMD_CHERI_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_CHERI_INSTALL_INIT_HOOK \
	SYSTEMD_CHERI_INSTALL_MACHINEID_HOOK \
	SYSTEMD_CHERI_INSTALL_RESOLVCONF_HOOK

define SYSTEMD_CHERI_INSTALL_IMAGES_CMDS
	$(SYSTEMD_CHERI_INSTALL_BOOT_FILES)
endef

define SYSTEMD_CHERI_USERS
	# udev user groups
	# systemd user groups
	- - systemd-journal -1 * - - - Journal
	$(SYSTEMD_CHERI_REMOTE_USER)
	$(SYSTEMD_CHERI_COREDUMP_USER)
	$(SYSTEMD_CHERI_NETWORKD_USER)
	$(SYSTEMD_CHERI_RESOLVED_USER)
	$(SYSTEMD_CHERI_TIMESYNCD_USER)
endef

define SYSTEMD_CHERI_INSTALL_NSSCONFIG_HOOK
	$(SED) '/^passwd:/ {/systemd/! s/$$/ systemd/}' \
		-e '/^group:/ {/systemd/! s/$$/ [SUCCESS=merge] systemd/}' \
		$(if $(BR2_PACKAGE_SYSTEMD_CHERI_RESOLVED), \
			-e '/^hosts:/ s/[[:space:]]*mymachines//' \
			-e '/^hosts:/ {/resolve/! s/files/files resolve [!UNAVAIL=return]/}' ) \
		$(if $(BR2_PACKAGE_SYSTEMD_CHERI_MYHOSTNAME), \
			-e '/^hosts:/ {/myhostname/! s/$$/ myhostname/}' ) \
		$(if $(BR2_PACKAGE_SYSTEMD_CHERI_MACHINED), \
			-e '/^passwd:/ {/mymachines/! s/files/files mymachines/}' \
			-e '/^group:/ {/mymachines/! s/files/files [SUCCESS=merge] mymachines/}' \
			-e '/^hosts:/ {/mymachines/! s/files/files mymachines/}' ) \
		$(TARGET_DIR)/etc/nsswitch.conf
endef

SYSTEMD_CHERI_TARGET_FINALIZE_HOOKS += SYSTEMD_CHERI_INSTALL_NSSCONFIG_HOOK

ifneq ($(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)),)
# systemd provides multiple units to autospawn getty as neede
# * getty@.service to start a getty on normal TTY
# * sertial-getty@.service to start a getty on serial lines
# * console-getty.service for generic /dev/console
# * container-getty@.service for a getty on /dev/pts/*
#
# the generator systemd-getty-generator will
# * read the console= kernel command line parameter
# * enable one of the above units depending on what it finds
#
# Systemd defaults to enablinb getty@tty1.service
#
# What we want to do
# * Enable a getty on $BR2_TARGET_GENERIC_TTY_PATH
# * Set the baudrate for all units according to BR2_TARGET_GENERIC_GETTY_BAUDRATE
# * Always enable a getty on the console using systemd-getty-generator
#   (backward compatibility with previous releases of buildroot)
#
# What we do
# * disable getty@tty1 (enabled by upstream systemd)
# * enable getty@xxx if  $BR2_TARGET_GENERIC_TTY_PATH is a tty
# * enable serial-getty@xxx for other $BR2_TARGET_GENERIC_TTY_PATH
# * rewrite baudrates if a baudrate is provided
define SYSTEMD_CHERI_INSTALL_SERVICE_TTY
	mkdir $(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d; \
	printf '[Install]\nDefaultInstance=\n' \
		>$(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d/buildroot-console.conf; \
	if [ $(BR2_TARGET_GENERIC_GETTY_PORT) = "console" ]; \
	then \
		: ; \
	elif echo $(BR2_TARGET_GENERIC_GETTY_PORT) | egrep -q 'tty[0-9]*$$'; \
	then \
		printf '[Install]\nDefaultInstance=%s\n' \
			$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)) \
			>$(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d/buildroot-console.conf; \
	else \
		mkdir $(TARGET_DIR)/usr/lib/systemd/system/serial-getty@.service.d;\
		printf '[Install]\nDefaultInstance=%s\n' \
			$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)) \
			>$(TARGET_DIR)/usr/lib/systemd/system/serial-getty@.service.d/buildroot-console.conf;\
	fi; \
	if [ $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE)) -gt 0 ] ; \
	then \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/serial-getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/console-getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/container-getty@.service; \
	fi
endef
endif

define SYSTEMD_CHERI_INSTALL_PRESET
	$(INSTALL) -D -m 644 $(SYSTEMD_CHERI_PKGDIR)/80-buildroot.preset $(TARGET_DIR)/usr/lib/systemd/system-preset/80-buildroot.preset
endef

define SYSTEMD_CHERI_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_CHERI_INSTALL_PRESET)
	$(SYSTEMD_CHERI_INSTALL_SERVICE_TTY)
	$(SYSTEMD_CHERI_INSTALL_NETWORK_CONFS)
endef

define SYSTEMD_CHERI_PRESET_ALL
	$(HOST_DIR)/bin/systemctl --root=$(TARGET_DIR) preset-all
endef
SYSTEMD_CHERI_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_CHERI_PRESET_ALL

SYSTEMD_CHERI_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_CHERI_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

define SYSTEMD_CHERI_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_CGROUPS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_FHANDLE)
	$(call KCONFIG_ENABLE_OPT,CONFIG_EPOLL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SIGNALFD)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TIMERFD)
	$(call KCONFIG_ENABLE_OPT,CONFIG_INOTIFY_USER)
	$(call KCONFIG_ENABLE_OPT,CONFIG_PROC_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SYSFS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_AUTOFS4_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_POSIX_ACL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_XATTR)
endef

# We need a very minimal host variant, so we disable as much as possible.
HOST_SYSTEMD_CHERI_CONF_OPTS = \
	-Dsplit-bin=true \
	-Dsplit-usr=false \
	--prefix=/usr \
	--libdir=lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	-Dutmp=false \
	-Dhibernate=false \
	-Dldconfig=false \
	-Dresolve=false \
	-Defi=false \
	-Dtpm=false \
	-Denvironment-d=false \
	-Dbinfmt=false \
	-Drepart=false \
	-Dcoredump=false \
	-Dpstore=false \
	-Dlogind=false \
	-Dhostnamed=false \
	-Dlocaled=false \
	-Dmachined=false \
	-Dportabled=false \
	-Duserdb=false \
	-Dhomed=false \
	-Dnetworkd=false \
	-Dtimedated=false \
	-Dtimesyncd=false \
	-Dremote=false \
	-Dcreate-log-dirs=false \
	-Dnss-myhostname=false \
	-Dnss-mymachines=false \
	-Dnss-resolve=false \
	-Dnss-systemd=false \
	-Dfirstboot=false \
	-Drandomseed=false \
	-Dbacklight=false \
	-Dvconsole=false \
	-Dquotacheck=false \
	-Dsysusers=false \
	-Dtmpfiles=false \
	-Dimportd=false \
	-Dhwdb=false \
	-Drfkill=false \
	-Dman=false \
	-Dhtml=false \
	-Dsmack=false \
	-Dpolkit=false \
	-Dblkid=false \
	-Didn=false \
	-Dadm-group=false \
	-Dwheel-group=false \
	-Dzlib=false \
	-Dgshadow=false \
	-Dima=false \
	-Dtests=false \
	-Dglib=false \
	-Dacl=false \
	-Dsysvinit-path='' \
	-Dinitrd=false \
	-Dxdg-autostart=false \
	-Dkernel-install=false \
	-Dsystemd-analyze=false \
	-Dlibcryptsetup=false \
	-Daudit=false \
	-Dzstd=false

HOST_SYSTEMD_CHERI_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	host-util-linux-cheri \
	host-patchelf \
	host-libcap \
	host-gperf

HOST_SYSTEMD_CHERI_NINJA_ENV = DESTDIR=$(HOST_DIR)

# Fix RPATH After installation
# * systemd provides a install_rpath instruction to meson because the binaries
#   need to link with libsystemd which is not in a standard path
# * meson can only replace the RPATH, not append to it
# * the original rpath is thus lost.
# * the original path had been tweaked by buildroot via LDFLAGS to add
#   $(HOST_DIR)/lib
# * thus re-tweak rpath after the installation for all binaries that need it
HOST_SYSTEMD_CHERI_HOST_TOOLS = busctl journalctl systemctl systemd-* udevadm

define HOST_SYSTEMD_CHERI_FIX_RPATH
	for f in $(addprefix $(HOST_DIR)/bin/,$(HOST_SYSTEMD_CHERI_HOST_TOOLS)); do \
		[ -e $$f ] || continue; \
		$(HOST_DIR)/bin/patchelf --set-rpath $(HOST_DIR)/lib:$(HOST_DIR)/lib/systemd $${f} \
		|| exit 1; \
	done
endef
HOST_SYSTEMD_CHERI_POST_INSTALL_HOOKS += HOST_SYSTEMD_CHERI_FIX_RPATH

$(eval $(meson-package))
$(eval $(host-meson-package))
