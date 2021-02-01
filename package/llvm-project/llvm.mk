################################################################################
#
# llvm-project
#
################################################################################

# LLVM, Clang and lld should be version bumped together
LLVM_PROJECT_VERSION = riscv-cheri-20220623
LLVM_PROJECT_SITE = https://github.com/cheri-linux/llvm-project.git
LLVM_PROJECT_SITE_METHOD=git
LLVM_PROJECT_LICENSE = Apache-2.0 with exceptions
#LLVM_PROJECT_LICENSE_FILES = LICENSE.TXT
LLVM_PROJECT_SUPPORTS_IN_SOURCE_BUILD = NO
LLVM_PROJECT_INSTALL_STAGING = YES

LLVM_PROJECT_SUBDIR = llvm
LLVM_PROJECT_CLANG = YES

# LLVM >= 9.0 can use python3 to build.
HOST_LLVM_PROJECT_DEPENDENCIES = host-python3
LLVM_PROJECT_DEPENDENCIES = host-llvm-project

# LLVM >= 9.0 will soon require C++14 support, building llvm 8.x using a
# toolchain using gcc < 5.1 gives an error but actually still works. Setting
# this option makes it still build with gcc >= 4.8.
# https://reviews.llvm.org/D57264
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=OFF

# Don't build clang libcxx libcxxabi lldb compiler-rt lld polly as llvm subprojects
# This flag assumes that projects are checked out side-by-side and not nested
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_PROJECTS="llvm;clang;lld"
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_PROJECTS="llvm;clang;lld"

HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_CCACHE_BUILD=$(if $(BR2_CCACHE),ON,OFF)
LLVM_PROJECT_CONF_OPTS += -DLLVM_CCACHE_BUILD=$(if $(BR2_CCACHE),ON,OFF)

# This option prevents AddLLVM.cmake from adding $ORIGIN/../lib to
# binaries. Otherwise, llvm-config (host variant installed in STAGING)
# will try to use target's libc.
HOST_LLVM_PROJECT_CONF_OPTS += -DCMAKE_INSTALL_RPATH="$(HOST_DIR)/cheri/lib"

# Get target architecture
LLVM_PROJECT_TARGET_ARCH = $(call qstrip,$(BR2_PACKAGE_LLVM_PROJECT_TARGET_ARCH))

# Build backend for target architecture. This include backends like AMDGPU.
LLVM_PROJECT_TARGETS_TO_BUILD =  $(call qstrip,$(BR2_PACKAGE_LLVM_PROJECT_TARGETS_TO_BUILD))
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(LLVM_PROJECT_TARGETS_TO_BUILD))"
LLVM_PROJECT_CONF_OPTS += -DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(LLVM_PROJECT_TARGETS_TO_BUILD))"

# LLVM target to use for native code generation. This is required for JIT generation.
# It must be set to LLVM_PROJECT_TARGET_ARCH for host and target, otherwise we get
# "No available targets are compatible for this triple" with llvmpipe when host
# and target architectures are different.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_TARGET_ARCH=$(LLVM_PROJECT_TARGET_ARCH)
LLVM_PROJECT_CONF_OPTS += -DLLVM_TARGET_ARCH=$(LLVM_PROJECT_TARGET_ARCH)

# Build AMDGPU backend
# We need to build AMDGPU backend for both host and target because
# llvm-config --targets built (host variant installed in STAGING) will
# output only $(LLVM_PROJECT_TARGET_ARCH) if not, and mesa3d won't build as
# it thinks AMDGPU backend is not installed on the target.
ifeq ($(BR2_PACKAGE_LLVM_PROJECT_AMDGPU),y)
LLVM_PROJECT_TARGETS_TO_BUILD += AMDGPU
endif

# Use native llvm-tblgen from host-llvm (needed for cross-compilation)
LLVM_PROJECT_CONF_OPTS += -DLLVM_TABLEGEN=$(HOST_DIR)/cheri/bin/llvm-tblgen

# Use native llvm-config from host-llvm (needed for cross-compilation)
LLVM_PROJECT_CONF_OPTS += -DLLVM_CONFIG_PATH=$(HOST_DIR)/cheri/bin/llvm-config

# BUILD_SHARED_LIBS has a misleading name. It is in fact an option for
# LLVM developers to build all LLVM libraries as separate shared libraries.
# For normal use of LLVM, it is recommended to build a single
# shared library, which is achieved by BUILD_SHARED_LIBS=OFF and
# LLVM_BUILD_LLVM_DYLIB=ON.
HOST_LLVM_PROJECT_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
LLVM_PROJECT_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

# Generate libLLVM.so. This library contains a default set of LLVM components
# that can be overwritten with "LLVM_DYLIB_COMPONENTS". The default contains
# most of LLVM and is defined in "tools/llvm-shlib/CMakelists.txt".
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_BUILD_LLVM_DYLIB=ON
LLVM_PROJECT_CONF_OPTS += -DLLVM_BUILD_LLVM_DYLIB=ON

# LLVM_BUILD_LLVM_DYLIB to ON. We need to enable this option for the
# host as llvm-config for the host will be used in STAGING_DIR by packages
# linking against libLLVM and if this option is not selected, then llvm-config
# does not work properly. For example, it assumes that LLVM is built statically
# and cannot find libLLVM.so.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON
LLVM_PROJECT_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON

LLVM_PROJECT_CONF_OPTS += -DCMAKE_CROSSCOMPILING=1

# Disabled for the host since no host-libedit.
# Fall back to "Simple fgets-based implementation" of llvm line editor.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBEDIT=OFF

# We want to install llvm libraries and modules.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

# We build from a release archive without vcs files.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_APPEND_VC_REV=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_APPEND_VC_REV=OFF

# No backtrace package in Buildroot.
# https://documentation.backtrace.io
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_BACKTRACES=OFF

# Enable signal handlers overrides support.
HOST_LLVM_PROJECT_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON
LLVM_PROJECT_CONF_OPTS += -DENABLE_CRASH_OVERRIDES=ON

# Disable ffi for now.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_FFI=OFF

# Disable terminfo database (needs ncurses libtinfo.so)
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_TERMINFO=OFF

# Enable thread support
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_THREADS=ON

# Enable optional host-zlib support for LLVM Machine Code (llvm-mc) to add
# compression/uncompression capabilities.
# Not needed on the target.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_ZLIB=ON
HOST_LLVM_DEPENDENCIES += host-zlib
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_ZLIB=OFF

# libxml2 can be disabled as it is used for LLVM Windows builds where COFF
# files include manifest info
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBXML2=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBXML2=OFF

# Disable optional Z3Prover since there is no such package in Buildroot.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_Z3_SOLVER=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_Z3_SOLVER=OFF

# We don't use llvm for static only build, so enable PIC
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_PIC=ON
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_PIC=ON

# Default is Debug build, which requires considerably more disk space and
# build time. Release build is selected for host and target because the linker
# can run out of memory in Debug mode.
HOST_LLVM_PROJECT_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
LLVM_PROJECT_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

# Disabled, requires sys/ndir.h header
# Disable debug in module
HOST_LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF

# Don't change the standard library to libc++.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LIBCXX=OFF

# Don't use lld as a linker.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_LLD=OFF

# Generate code for the target. LLVM selects a target by looking at the
# toolchain tuple
# default target triple should not be set for host to be X86
#HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(GNU_TARGET_NAME)
LLVM_PROJECT_CONF_OPTS += -DLLVM_DEFAULT_TARGET_TRIPLE=$(GNU_TARGET_NAME)

# LLVM_HOST_TRIPLE has a misleading name, it is in fact the triple of the
# system where llvm is going to run on. We need to specify triple for native
# code generation on the target.
# This solves "No available targets are compatible for this triple" with llvmpipe
LLVM_PROJECT_CONF_OPTS += -DLLVM_HOST_TRIPLE=$(GNU_TARGET_NAME)

# The Go bindings have no CMake rules at the moment, but better remove the
# check preventively. Building the Go and OCaml bindings is yet unsupported.
HOST_LLVM_PROJECT_CONF_OPTS += \
	-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND \
	-DOCAMLFIND=OCAMLFIND-NOTFOUND

# Builds a release host tablegen that gets used during the LLVM build.
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_OPTIMIZED_TABLEGEN=ON

# Keep llvm utility binaries for the host. llvm-tblgen is built anyway as
# CMakeLists.txt has add_subdirectory(utils/TableGen) unconditionally.
HOST_LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_BUILD_UTILS=ON \
	-DLLVM_INCLUDE_UTILS=ON \
	-DLLVM_INSTALL_UTILS=ON
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_BUILD_UTILS=OFF \
	-DLLVM_INCLUDE_UTILS=OFF \
	-DLLVM_INSTALL_UTILS=OFF

HOST_LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_BUILD_TOOLS=ON

# We need to activate LLVM_INCLUDE_TOOLS, otherwise it does not generate
# libLLVM.so
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_BUILD_TOOLS=OFF

ifeq ($(BR2_PACKAGE_LLVM_RTTI),y)
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_RTTI=ON
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_RTTI=ON
else
HOST_LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_RTTI=OFF
LLVM_PROJECT_CONF_OPTS += -DLLVM_ENABLE_RTTI=OFF
endif

# Compiler-rt not in the source tree.
# llvm runtime libraries are not in the source tree.
# Polly is not in the source tree.
HOST_LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
	-DLLVM_BUILD_RUNTIME=OFF \
	-DLLVM_INCLUDE_RUNTIMES=OFF \
	-DLLVM_POLLY_BUILD=OFF
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
	-DLLVM_BUILD_RUNTIME=OFF \
	-DLLVM_INCLUDE_RUNTIMES=OFF \
	-DLLVM_POLLY_BUILD=OFF

HOST_LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_WERROR=OFF
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_WERROR=OFF

HOST_LLVM_PROJECT_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX=$(HOST_DIR)/cheri \
	-DLLVM_PARALLEL_LINK_JOBS=8 \
	-DLLVM_ENABLE_LTO=Off \
	-DLLVM_TOOL_LTO_BUILD=Off \
	-DLLVM_INSTALL_BINUTILS_SYMLINKS=On \
	-DLLVM_ENABLE_DUMP=On \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_OCAMLDOC=OFF \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_GO_TESTS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF
LLVM_PROJECT_CONF_OPTS += \
	-DLLVM_PARALLEL_LINK_JOBS=8 \
	-DLLVM_INSTALL_BINUTILS_SYMLINKS=On \
	-DLLVM_ENABLE_LTO=Off \
	-DLLVM_TOOL_LTO_BUILD=Off \
	-DLLVM_ENABLE_DUMP=On \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_OCAMLDOC=OFF \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_GO_TESTS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF

# Copy llvm-config (host variant) to STAGING_DIR
# llvm-config (host variant) returns include and lib directories
# for the host if it's installed in host/bin:
# output/host/bin/llvm-config --includedir
# output/host/include
# When installed in STAGING_DIR, llvm-config returns include and lib
# directories from STAGING_DIR.
# output/staging/usr/bin/llvm-config --includedir
# output/staging/usr/include
define HOST_LLVM_PROJECT_COPY_LLVM_CONFIG_TO_STAGING_DIR
	$(INSTALL) -D -m 0755 $(HOST_DIR)/cheri/bin/llvm-config \
		$(STAGING_DIR)/cheri/usr/bin/llvm-config
endef

HOST_LLVM_PROJECT_POST_INSTALL_HOOKS = HOST_LLVM_PROJECT_COPY_LLVM_CONFIG_TO_STAGING_DIR

#$(GNU_TARGET_NAME)

define HOST_LLVM_PROJECT_INSTALL_WRAPPER_AND_SYMLINKS
	sed -e 's#@@CHERI_LDSO@@#$(CHERI_LDSO)#' $(TOPDIR)/$(HOST_LLVM_PROJECT_PKGDIR)/lld-wrapper \
	> $(HOST_DIR)/cheri/bin/lld-wrapper
	chmod 0755 $(HOST_DIR)/cheri/bin/lld-wrapper
	$(Q)$(INSTALL) -D $(TOPDIR)/$(HOST_LLVM_PROJECT_PKGDIR)/clang-wrapper \
		$(HOST_DIR)/cheri/bin/clang-wrapper
	ln -sfr $(HOST_DIR)/cheri/bin/clang-wrapper $(TARGET_CC_CLANG); \
	ln -sfr $(HOST_DIR)/cheri/bin/clang-wrapper $(TARGET_CXX_CLANG); \
	ln -sfr $(HOST_DIR)/cheri/bin/clang-wrapper $(TARGET_CPP_CLANG); \
	ln -sfr $(HOST_DIR)/cheri/bin/lld-wrapper $(TARGET_LD_CLANG); \
	cd $(HOST_DIR)/cheri/bin; \
	for i in llvm-*; do \
		case "$$i" in \
		*.br_real) \
			;; \
		*cc|*cc-*|*++|*++-*|*cpp|*-gfortran|*-gdc) \
			;; \
		*) \
			ln -snf $$i $(TARGET_NAME_CLANG)$${i##llvm}; \
			;; \
		esac; \
	done
endef

HOST_LLVM_PROJECT_POST_INSTALL_HOOKS += HOST_LLVM_PROJECT_INSTALL_WRAPPER_AND_SYMLINKS

# By default llvm-tblgen is built and installed on the target but it is
# not necessary. Also erase LLVMHello.so from /usr/lib
define LLVM_PROJECT_DELETE_LLVM_TBLGEN_TARGET
	rm -f $(TARGET_DIR)/usr/bin/llvm-tblgen $(TARGET_DIR)/usr/lib/LLVMHello.so
endef
LLVM_PROJECT_POST_INSTALL_TARGET_HOOKS = LLVM_PROJECT_DELETE_LLVM_TBLGEN_TARGET

BR_PATH = $(HOST_DIR)/bin:$(HOST_DIR)/sbin:$(HOST_DIR)/cheri/bin:$(PATH)

#BR_PATH_OLD = $(call qstrip,$(value BR_PATH))
#$(info old: $(BR_PATH_OLD))
#BR_PATH = $(BR_PATH_OLD):$(HOST_DIR)/cheri/bin
#$(info new: $(value BR_PATH))
#$(error done)

$(eval $(cmake-package))
$(eval $(host-cmake-package))
