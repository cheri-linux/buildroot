################################################################################
#
# libopenssl-cheri
#
################################################################################

LIBOPENSSL_CHERI_VERSION = riscv-cheri-20220623
LIBOPENSSL_CHERI_SITE = https://github.com/cheri-linux/openssl.git
LIBOPENSSL_CHERI_SITE_METHOD = git

LIBOPENSSL_CHERI_INSTALL_STAGING = YES
LIBOPENSSL_CHERI_DEPENDENCIES = zlib
# no-asm is needed with generic architectures such as linux-generic32, see
# https://github.com/openssl/openssl/issues/9839
LIBOPENSSL_CHERI_TARGET_ARCH = linux-generic64 no-asm
LIBOPENSSL_CHERI_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBOPENSSL_CHERI_CFLAGS += -DOPENSSL_THREADS
endif

ifeq ($(BR2_USE_MMU),)
LIBOPENSSL_CHERI_CFLAGS += -DHAVE_FORK=0 -DOPENSSL_NO_MADVISE
endif

ifeq ($(BR2_PACKAGE_HAS_CRYPTODEV),y)
LIBOPENSSL_CHERI_DEPENDENCIES += cryptodev
endif

# fixes the following build failures:
#
# - musl
#   ./libcrypto.so: undefined reference to `getcontext'
#   ./libcrypto.so: undefined reference to `setcontext'
#   ./libcrypto.so: undefined reference to `makecontext'
#
# - uclibc:
#   crypto/async/arch/../arch/async_posix.h:32:5: error: unknown type name 'ucontext_t'
#

ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LIBOPENSSL_CHERI_CFLAGS += -DOPENSSL_NO_ASYNC
endif
ifeq ($(BR2_TOOLCHAIN_HAS_UCONTEXT),)
LIBOPENSSL_CHERI_CFLAGS += -DOPENSSL_NO_ASYNC
endif

define LIBOPENSSL_CHERI_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			$(LIBOPENSSL_CHERI_TARGET_ARCH) \
			CC=$(TARGET_CC_CLANG) \
			--prefix=/cheri/usr \
			--openssldir=/cheri/etc/ssl \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),-lpthread threads, no-threads) \
			$(if $(BR2_STATIC_LIBS),no-shared,shared) \
			$(if $(BR2_PACKAGE_HAS_CRYPTODEV),enable-devcryptoeng) \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			no-tests \
			no-fuzz-libfuzzer \
			no-fuzz-afl \
			$(if $(BR2_STATIC_LIBS),zlib,zlib-dynamic) \
	)
	$(SED) "s#-march=[-a-z0-9] ##" -e "s#-mcpu=[-a-z0-9] ##g" $(@D)/Makefile
	$(SED) "s#-O[0-9s]#$(LIBOPENSSL_CHERI_CFLAGS)#" $(@D)/Makefile
	$(SED) "s# build_tests##" $(@D)/Makefile
endef

define LIBOPENSSL_CHERI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LIBOPENSSL_CHERI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define LIBOPENSSL_CHERI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/lib/ssl
	rm -f $(TARGET_DIR)/usr/bin/c_rehash
endef

ifeq ($(BR2_PACKAGE_PERL),)
define LIBOPENSSL_CHERI_REMOVE_PERL_SCRIPTS
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.pl,tsget}
endef
LIBOPENSSL_CHERI_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_CHERI_REMOVE_PERL_SCRIPTS
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL_CHERI_BIN),)
define LIBOPENSSL_CHERI_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.*,c_*}
endef
LIBOPENSSL_CHERI_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_CHERI_REMOVE_BIN
endif

ifneq ($(BR2_PACKAGE_LIBOPENSSL_CHERI_ENGINES),y)
define LIBOPENSSL_CHERI_REMOVE_LIBOPENSSL_CHERI_ENGINES
	rm -rf $(TARGET_DIR)/usr/lib/engines-1.1
endef
LIBOPENSSL_CHERI_POST_INSTALL_TARGET_HOOKS += LIBOPENSSL_CHERI_REMOVE_LIBOPENSSL_CHERI_ENGINES
endif

$(eval $(generic-package))
