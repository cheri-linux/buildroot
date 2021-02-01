################################################################################
#
# toolchain-cheri
#
################################################################################

CHERI_LIBC = $(call qstrip,$(BR2_TOOLCHAIN_CHERI_LIBC))

# Trigger build of all relevant packages
TOOLCHAIN_CHERI_DEPENDENCIES = $(CHERI_LIBC)

TOOLCHAIN_CHERI_ADD_TOOLCHAIN_DEPENDENCY = NO

$(eval $(virtual-package))
