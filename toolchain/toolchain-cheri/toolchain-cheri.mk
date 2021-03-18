################################################################################
#
# toolchain-cheri
#
################################################################################

CHERI_LIBC = $(call qstrip,$(BR2_TOOLCHAIN_CHERI_LIBC))

ifeq ($(BR2_RISCV_64),y)
ifeq ($(CHERI_LIBC),musl-cheri)
CHERI_LDSO = /lib/ld-musl-$(TARGET_ARCH_CLANG)-clang.so.1
else ifeq ($(BR2_RISCV_CHERI)$(CHERI_LIBC),yglibc-cheri)
CHERI_LDSO = /lib/ld-linux-riscv64-l64pc128d.so.1
else ifeq ($(BR2_RISCV_CHERI)$(CHERI_LIBC),glibc-cheri)
CHERI_LDSO = /lib/ld-linux-riscv64-lp64d.so.1
endif
endif

# Trigger build of all relevant packages
TOOLCHAIN_CHERI_DEPENDENCIES = $(CHERI_LIBC)

TOOLCHAIN_CHERI_ADD_TOOLCHAIN_DEPENDENCY = NO

$(eval $(virtual-package))
