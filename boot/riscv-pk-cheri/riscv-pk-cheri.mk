################################################################################
#
# riscv-pk-cheri
#
################################################################################

RISCV_PK_CHERI_VERSION = riscv-cheri-20220623
RISCV_PK_CHERI_SITE = https://github.com/cheri-linux/riscv-pk.git
RISCV_PK_CHERI_SITE_METHOD = git

RISCV_PK_CHERI_DEPENDENCIES = host-llvm-project musl-cheri
RISCV_PK_CHERI_INSTALL_IMAGES = YES

ifeq ($(BR2_TARGET_RISCV_PK_CHERI_QEMU),y)
MEM_START=0x80000000
GFE=
endif

ifeq ($(BR2_TARGET_RISCV_PK_CHERI_GFE),y)
MEM_START=0xc0000000
GFE=--enable-board-gfe
endif

define RISCV_PK_CHERI_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	(cd $(@D)/build; \
		$(TARGET_CONFIGURE_OPTS) ../configure \
		CC=$(TARGET_CC_CLANG) \
		--host=$(GNU_TARGET_NAME) \
		--enable-logo \
		--with-mem-start=$(MEM_START) \
		--without-payload $(GFE) \
	)
endef

define RISCV_PK_CHERI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/build bbl
endef

define RISCV_PK_CHERI_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/bbl $(BINARIES_DIR)/bbl
endef

$(eval $(generic-package))
