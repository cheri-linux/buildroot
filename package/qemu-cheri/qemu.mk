################################################################################
#
# qemu-cheri
#
################################################################################

QEMU_CHERI_VERSION = cheri-rel-20210817
QEMU_CHERI_SITE = https://github.com/CTSRD-CHERI/qemu.git
QEMU_CHERI_SITE_METHOD = git
QEMU_CHERI_GIT_SUBMODULES = YES

QEMU_CHERI_SUPPORTS_IN_SOURCE_BUILD = NO

QEMU_CHERI_LICENSE = GPL-2.0, LGPL-2.1, MIT, BSD-3-Clause, BSD-2-Clause, Others/BSD-1c
QEMU_CHERI_LICENSE_FILES = COPYING COPYING.LIB
# NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.

#-------------------------------------------------------------
# Target-qemu
QEMU_CHERI_DEPENDENCIES = host-pkgconf libglib2 zlib pixman host-python3

# Need the LIBS variable because librt and libm are
# not automatically pulled. :-(
QEMU_CHERI_LIBS = -lrt -lm

QEMU_CHERI_OPTS =

QEMU_CHERI_VARS = LIBTOOL=$(HOST_DIR)/bin/libtool

# If we want to specify only a subset of targets, we must still enable all
# of them, so that QEMU properly builds its list of default targets, from
# which it then checks if the specified sub-set is valid. That's what we
# do in the first part of the if-clause.
# Otherwise, if we do not want to pass a sub-set of targets, we then need
# to either enable or disable -user and/or -system emulation appropriately.
# That's what we do in the else-clause.
ifneq ($(call qstrip,$(BR2_PACKAGE_QEMU_CHERI_CUSTOM_TARGETS)),)
QEMU_CHERI_OPTS += --enable-system --enable-linux-user
QEMU_CHERI_OPTS += --target-list="$(call qstrip,$(BR2_PACKAGE_QEMU_CHERI_CUSTOM_TARGETS))"
else

ifeq ($(BR2_PACKAGE_QEMU_CHERI_SYSTEM),y)
QEMU_CHERI_OPTS += --enable-system
else
QEMU_CHERI_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_QEMU_CHERI_LINUX_USER),y)
QEMU_CHERI_OPTS += --enable-linux-user
else
QEMU_CHERI_OPTS += --disable-linux-user
endif

endif

ifeq ($(BR2_PACKAGE_QEMU_CHERI_SLIRP),y)
QEMU_CHERI_OPTS += --enable-slirp=system
QEMU_CHERI_DEPENDENCIES += slirp
else
QEMU_CHERI_OPTS += --disable-slirp
endif

ifeq ($(BR2_PACKAGE_QEMU_CHERI_SDL),y)
QEMU_CHERI_OPTS += --enable-sdl
QEMU_CHERI_DEPENDENCIES += sdl2
QEMU_CHERI_VARS += SDL2_CONFIG=$(BR2_STAGING_DIR)/usr/bin/sdl2-config
else
QEMU_CHERI_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_QEMU_CHERI_FDT),y)
QEMU_CHERI_OPTS += --enable-fdt
QEMU_CHERI_DEPENDENCIES += dtc
else
QEMU_CHERI_OPTS += --disable-fdt
endif

ifeq ($(BR2_PACKAGE_QEMU_CHERI_TOOLS),y)
QEMU_CHERI_OPTS += --enable-tools
else
QEMU_CHERI_OPTS += --disable-tools
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
QEMU_CHERI_OPTS += --enable-seccomp
QEMU_CHERI_DEPENDENCIES += libseccomp
else
QEMU_CHERI_OPTS += --disable-seccomp
endif

ifeq ($(BR2_PACKAGE_LIBSSH),y)
QEMU_CHERI_OPTS += --enable-libssh
QEMU_CHERI_DEPENDENCIES += libssh
else
QEMU_CHERI_OPTS += --disable-libssh
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
QEMU_CHERI_OPTS += --enable-libusb
QEMU_CHERI_DEPENDENCIES += libusb
else
QEMU_CHERI_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_LIBVNCSERVER),y)
QEMU_CHERI_OPTS += \
	--enable-vnc \
	--disable-vnc-sasl
QEMU_CHERI_DEPENDENCIES += libvncserver
ifeq ($(BR2_PACKAGE_LIBPNG),y)
QEMU_CHERI_OPTS += --enable-vnc-png
QEMU_CHERI_DEPENDENCIES += libpng
else
QEMU_CHERI_OPTS += --disable-vnc-png
endif
ifeq ($(BR2_PACKAGE_JPEG),y)
QEMU_CHERI_OPTS += --enable-vnc-jpeg
QEMU_CHERI_DEPENDENCIES += jpeg
else
QEMU_CHERI_OPTS += --disable-vnc-jpeg
endif
else
QEMU_CHERI_OPTS += --disable-vnc
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
QEMU_CHERI_OPTS += --enable-nettle
QEMU_CHERI_DEPENDENCIES += nettle
else
QEMU_CHERI_OPTS += --disable-nettle
endif

ifeq ($(BR2_PACKAGE_NUMACTL),y)
QEMU_CHERI_OPTS += --enable-numa
QEMU_CHERI_DEPENDENCIES += numactl
else
QEMU_CHERI_OPTS += --disable-numa
endif

QEMU_CHERI_OPTS += --disable-stack-protector --disable-rdma
QEMU_CHERI_OPTS += --disable-werror --disable-pie

ifeq ($(BR2_PACKAGE_SPICE),y)
QEMU_CHERI_OPTS += --enable-spice
QEMU_CHERI_DEPENDENCIES += spice
else
QEMU_CHERI_OPTS += --disable-spice
endif

ifeq ($(BR2_PACKAGE_USBREDIR),y)
QEMU_CHERI_OPTS += --enable-usb-redir
QEMU_CHERI_DEPENDENCIES += usbredir
else
QEMU_CHERI_OPTS += --disable-usb-redir
endif

# Override CPP, as it expects to be able to call it like it'd
# call the compiler.
define QEMU_CHERI_CONFIGURE_CMDS
	unset TARGET_DIR; \
	cd $(@D); \
		LIBS='$(QEMU_CHERI_LIBS)' \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPP="$(TARGET_CC) -E" \
		$(QEMU_CHERI_VARS) \
		./configure \
			--prefix=/usr \
			--cross-prefix=$(TARGET_CROSS) \
			--audio-drv-list= \
			--python=$(HOST_DIR)/bin/python3 \
			--enable-kvm \
			--enable-attr \
			--enable-vhost-net \
			--disable-bsd-user \
			--disable-containers \
			--disable-xen \
			--disable-virtfs \
			--disable-brlapi \
			--disable-curses \
			--disable-curl \
			--disable-vde \
			--disable-linux-aio \
			--disable-linux-io-uring \
			--disable-cap-ng \
			--disable-docs \
			--disable-rbd \
			--disable-libiscsi \
			--disable-strip \
			--disable-sparse \
			--disable-mpath \
			--disable-sanitizers \
			--disable-hvf \
			--disable-whpx \
			--disable-malloc-trim \
			--disable-membarrier \
			--disable-vhost-crypto \
			--disable-libxml2 \
			--disable-capstone \
			--disable-git-update \
			--disable-opengl \
			$(QEMU_CHERI_OPTS)
endef

define QEMU_CHERI_BUILD_CMDS
	unset TARGET_DIR; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_CHERI_INSTALL_TARGET_CMDS
	unset TARGET_DIR; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(QEMU_CHERI_MAKE_ENV) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))

#-------------------------------------------------------------
# Host-qemu

HOST_QEMU_CHERI_DEPENDENCIES = host-pkgconf host-zlib host-libglib2 host-pixman host-python3

#       BR ARCH         qemu
#       -------         ----
#       arm             arm
#       armeb           armeb
#       i486            i386
#       i586            i386
#       i686            i386
#       x86_64          x86_64
#       m68k            m68k
#       microblaze      microblaze
#       mips            mips
#       mipsel          mipsel
#       mips64          mips64
#       mips64el        mips64el
#       nios2           nios2
#       or1k            or1k
#       powerpc         ppc
#       powerpc64       ppc64
#       powerpc64le     ppc64 (system) / ppc64le (usermode)
#       sh2a            not supported
#       sh4             sh4
#       sh4eb           sh4eb
#       sh4a            sh4
#       sh4aeb          sh4eb
#       sparc           sparc
#       sparc64         sparc64
#       xtensa          xtensa

HOST_QEMU_CHERI_ARCH = $(ARCH)
ifeq ($(HOST_QEMU_CHERI_ARCH),i486)
HOST_QEMU_CHERI_ARCH = i386
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),i586)
HOST_QEMU_CHERI_ARCH = i386
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),i686)
HOST_QEMU_CHERI_ARCH = i386
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),powerpc)
HOST_QEMU_CHERI_ARCH = ppc
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),powerpc64)
HOST_QEMU_CHERI_ARCH = ppc64
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),powerpc64le)
HOST_QEMU_CHERI_ARCH = ppc64le
HOST_QEMU_CHERI_SYS_ARCH = ppc64
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),sh4a)
HOST_QEMU_CHERI_ARCH = sh4
endif
ifeq ($(HOST_QEMU_CHERI_ARCH),sh4aeb)
HOST_QEMU_CHERI_ARCH = sh4eb
endif
HOST_QEMU_CHERI_SYS_ARCH ?= $(HOST_QEMU_CHERI_ARCH)

HOST_QEMU_CHERI_CFLAGS = $(HOST_CFLAGS)

HOST_QEMU_CHERI_LDFLAGS = $(HOST_LDFLAGS)
HOST_QEMU_CHERI_LDFLAGS += -fuse-ld=lld

ifeq ($(BR2_PACKAGE_HOST_QEMU_CHERI_SYSTEM_MODE),y)
HOST_QEMU_CHERI_TARGETS += $(HOST_QEMU_CHERI_SYS_ARCH)-softmmu
ifeq ($(BR2_MIPS_CHERI128),y)
HOST_QEMU_CHERI_TARGETS += cheri256-softmmu cheri128-softmmu cheri128magic-softmmu
endif
ifeq ($(BR2_riscv),y)
HOST_QEMU_CHERI_TARGETS += $(HOST_QEMU_CHERI_SYS_ARCH)cheri-softmmu
endif
HOST_QEMU_CHERI_OPTS += --enable-system --enable-fdt
HOST_QEMU_CHERI_CFLAGS += -I$(HOST_DIR)/include/libfdt
HOST_QEMU_CHERI_DEPENDENCIES += host-dtc
else
HOST_QEMU_CHERI_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_HOST_QEMU_CHERI_LINUX_USER_MODE),y)
HOST_QEMU_CHERI_TARGETS += $(HOST_QEMU_CHERI_ARCH)-linux-user
HOST_QEMU_CHERI_OPTS += --enable-linux-user

HOST_QEMU_CHERI_HOST_SYSTEM_TYPE = $(shell uname -s)
ifneq ($(HOST_QEMU_CHERI_HOST_SYSTEM_TYPE),Linux)
$(error "qemu-user can only be used on Linux hosts")
endif

else # BR2_PACKAGE_HOST_QEMU_CHERI_LINUX_USER_MODE
HOST_QEMU_CHERI_OPTS += --disable-linux-user
endif # BR2_PACKAGE_HOST_QEMU_CHERI_LINUX_USER_MODE

ifeq ($(BR2_PACKAGE_HOST_QEMU_CHERI_VDE2),y)
HOST_QEMU_CHERI_OPTS += --enable-vde
HOST_QEMU_CHERI_DEPENDENCIES += host-vde2
endif

# virtfs-proxy-helper is the only user of libcap-ng.
ifeq ($(BR2_PACKAGE_HOST_QEMU_CHERI_VIRTFS),y)
HOST_QEMU_CHERI_OPTS += --enable-virtfs --enable-cap-ng
HOST_QEMU_CHERI_DEPENDENCIES += host-libcap-ng
else
HOST_QEMU_CHERI_OPTS += --disable-virtfs --disable-cap-ng
endif

ifeq ($(BR2_PACKAGE_HOST_QEMU_CHERI_USB),y)
HOST_QEMU_CHERI_OPTS += --enable-libusb
HOST_QEMU_CHERI_DEPENDENCIES += host-libusb
else
HOST_QEMU_CHERI_OPTS += --disable-libusb
endif

HOST_QEMU_CHERI_OPTS += --disable-vnc --disable-sdl --disable-gtk --disable-opengl
HOST_QEMU_CHERI_OPTS += --disable-stack-protector --disable-strip
HOST_QEMU_CHERI_OPTS += --disable-capstone #--smbd=/usr/sbin/smbd
HOST_QEMU_CHERI_OPTS += --disable-bsd-user --disable-xen --disable-docs --disable-rdma
HOST_QEMU_CHERI_OPTS += --disable-werror --disable-pie

HOST_QEMU_CHERI_CFLAGS += -DCHERI_UNALIGNED -Werror=implicit-function-declaration
HOST_QEMU_CHERI_CFLAGS += -Werror=incompatible-pointer-types-discards-qualifiers -Wno-address-of-packed-member
HOST_QEMU_CHERI_CFLAGS += -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-c11-extensions
HOST_QEMU_CHERI_CFLAGS += -Wno-missing-field-initializers -Wall -Werror=return-type

# Override CPP, as it expects to be able to call it like it'd
# call the compiler.
define HOST_QEMU_CHERI_CONFIGURE_CMDS
	unset TARGET_DIR; \
	cd $(@D); $(HOST_CONFIGURE_OPTS) CPP="$(HOSTCC_CLANG) -E" \
		./configure \
		--target-list="$(HOST_QEMU_CHERI_TARGETS)" \
		--prefix="$(HOST_DIR)/cheri" \
		--interp-prefix=$(STAGING_DIR) \
		--cc="$(HOSTCC_CLANG)" \
		--cxx="$(HOSTCXX_CLANG)" \
		--host-cc="$(HOSTCC_CLANG)" \
		--extra-cflags="$(HOST_QEMU_CHERI_CFLAGS)" \
		--extra-ldflags="$(HOST_QEMU_CHERI_LDFLAGS)" \
		--python=$(HOST_DIR)/bin/python3 \
		--disable-bzip2 \
		--disable-containers \
		--disable-curl \
		--disable-libssh \
		--disable-linux-io-uring \
		--disable-sdl \
		--disable-vnc-jpeg \
		--disable-vnc-png \
		--disable-vnc-sasl \
		$(HOST_QEMU_CHERI_OPTS)
endef

define HOST_QEMU_CHERI_BUILD_CMDS
	unset TARGET_DIR; \
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_QEMU_CHERI_INSTALL_CMDS
	unset TARGET_DIR; \
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(host-generic-package))

# variable used by other packages
QEMU_CHERI_USER = $(HOST_DIR)/cheri/bin/qemu-$(HOST_QEMU_CHERI_ARCH)
