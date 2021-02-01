################################################################################
#
# compiler-rt
#
################################################################################

COMPILER_RT_VERSION = riscv-cheri-20220623
COMPILER_RT_SITE = https://github.com/cheri-linux/llvm-project.git
COMPILER_RT_SITE_METHOD=git
COMPILER_RT_LICENSE = Apache-2.0 with exceptions
COMPILER_RT_SUPPORTS_IN_SOURCE_BUILD = NO
COMPILER_RT_INSTALL_STAGING = YES

COMPILER_RT_DL_SUBDIR = llvm-project

COMPILER_RT_SUBDIR = compiler-rt
COMPILER_RT_CLANG = YES

COMPILER_RT_DEPENDENCIES = host-llvm-project $(CHERI_LIBC)-headers

# compiler-rt is part of the toolchain so disable the toolchain dependency
COMPILER_RT_ADD_TOOLCHAIN_DEPENDENCY = NO

COMPILER_RT_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

COMPILER_RT_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX="" \
	-DCMAKE_C_FLAGS="-nostdlib -D_GNU_SOURCE" \
	-DCMAKE_CXX_FLAGS="-nostdlib -D_GNU_SOURCE" \
	-DCOMPILER_RT_BUILD_BUILTINS=ON \
	-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
	-DCOMPILER_RT_BUILD_XRAY=OFF \
	-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
	-DCOMPILER_RT_BUILD_PROFILE=OFF \
	-DCOMPILER_RT_BUILD_MEMPROF=OFF \
	-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON

define COMPILER_RT_POST_INSTALL_HOOK
	ln -sfr $(STAGING_DIR)/cheri/lib/linux/libclang_rt.builtins-$(ARCH).a $(STAGING_DIR)/cheri/lib/libclang_rt.builtins-$(ARCH).a
	ln -sfr $(STAGING_DIR)/cheri/lib/linux/clang_rt.crtbegin-$(ARCH).o $(STAGING_DIR)/cheri/lib/clang_rt.crtbegin-$(ARCH).o
	ln -sfr $(STAGING_DIR)/cheri/lib/linux/clang_rt.crtend-$(ARCH).o $(STAGING_DIR)/cheri/lib/clang_rt.crtend-$(ARCH).o
endef

COMPILER_RT_POST_INSTALL_STAGING_HOOKS += COMPILER_RT_POST_INSTALL_HOOK

$(eval $(cmake-package))
