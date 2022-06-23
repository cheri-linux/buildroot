################################################################################
#
# musl
#
################################################################################

#MUSL_CHERI_HEADERS_VERSION = 1.1.24
#MUSL_CHERI_HEADERS_SITE = http://www.musl-libc.org/releases
MUSL_CHERI_HEADERS_VERSION = riscv-cheri-20220623
MUSL_CHERI_HEADERS_SITE = https://github.com/cheri-linux/musl.git
MUSL_CHERI_HEADERS_SITE_METHOD = git
MUSL_CHERI_HEADERS_LICENSE = MIT
MUSL_CHERI_HEADERS_LICENSE_FILES = COPYRIGHT

MUSL_CHERI_HEADERS_DL_SUBDIR = musl-cheri

# Before musl is configured, we must have the first stage
# cross-compiler and the kernel headers
MUSL_CHERI_HEADERS_DEPENDENCIES = host-llvm-project linux-headers

# musl does not provide an implementation for sys/queue.h or sys/cdefs.h.
# So, add the musl-compat-headers package that will install those files,
# into the staging directory:
#   sys/queue.h:  header from NetBSD
#   sys/cdefs.h:  minimalist header bundled in Buildroot
MUSL_CHERI_HEADERS_DEPENDENCIES += musl-compat-headers

# musl is part of the toolchain so disable the toolchain dependency
MUSL_CHERI_HEADERS_ADD_TOOLCHAIN_DEPENDENCY = NO

MUSL_CHERI_HEADERS_INSTALL_STAGING = YES
MUSL_CHERI_HEADERS_INSTALL_TARGET = NO
MUSL_CHERI_HEADERS_CLANG = YES

# Thumb build is broken, build in ARM mode, since all architectures
# that support Thumb1 also support ARM.
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
MUSL_CHERI_HEADERS_EXTRA_CFLAGS += -marm
endif

ifeq ($(BR2_MIPS_CHERI128),y)
MUSL_CHERI_HEADERS_EXTRA_CFLAGS += -Wl,--Bshareable -nostdlib
endif

define MUSL_CHERI_HEADERS_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS)) $(MUSL_CHERI_HEADERS_EXTRA_CFLAGS)" \
		CPPFLAGS="$(filter-out -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))" \
		CC="$(TARGET_CC_CLANG)" \
		./configure \
			--target=$(GNU_TARGET_NAME) \
			--host=$(GNU_TARGET_NAME) \
			--prefix=/cheri/usr \
			--libdir=/cheri/lib \
			--syslibdir=/cheri/lib \
			--disable-gcc-wrapper \
			--enable-static \
			$(if $(BR2_STATIC_LIBS),--disable-shared,--enable-shared))
endef

#define MUSL_CHERI_HEADERS_BUILD_CMDS
#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
#endef

define MUSL_CHERI_HEADERS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(STAGING_DIR) install-headers
endef

#define MUSL_CHERI_HEADERS_INSTALL_TARGET_CMDS
#	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
#		DESTDIR=$(TARGET_DIR) install-libs
#	$(RM) $(addprefix $(TARGET_DIR)/cheri/lib/,crt1.o crtn.o crti.o rcrt1.o Scrt1.o)
#endef

$(eval $(generic-package))
