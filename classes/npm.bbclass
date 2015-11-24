DEPENDS += " node-native"

RDEPENDS_${PN} += " node"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM ?= "npm"
NPM_CACHE_DIR = "${WORKDIR}/npm_cache"
NPM_ARCH ?= "${TARGET_ARCH}"
NPM_LD ?= "${CXX}"
NPM_FLAGS ?= ""
NPM_REGISTRY ?= "https://registry.npmjs.org/"

# Target npm

oe_runnpm() {

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR}"

	bbnote NPM target architecture: ${NPM_ARCH}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}

	bbnote ${NPM} --registry=${NPM_REGISTRY} --arch=${NPM_ARCH} --target_arch=${NPM_ARCH} ${NPM_FLAGS} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD}" ${NPM} --registry=${NPM_REGISTRY} --arch=${NPM_ARCH} --target_arch=${NPM_ARCH} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"

}

# Native npm

NPM_NATIVE ?= "npm"
NPM_CACHE_DIR_NATIVE = "${WORKDIR}/npm_cache"
NPM_ARCH_NATIVE ?= "${BUILD_ARCH}"
NPM_LD_NATIVE ?= "${BUILD_CXX}"
NPM_FLAGS_NATIVE ?= ""

oe_runnpm_native() {

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR_NATIVE}"

	bbnote NPM native architecture: ${NPM_ARCH_NATIVE}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}

	bbnote ${NPM_NATIVE} --arch=${NPM_ARCH_NATIVE} --target_arch=${NPM_ARCH_NATIVE} ${NPM_FLAGS_NATIVE} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD_NATIVE}" ${NPM_NATIVE} --arch=${NPM_ARCH_NATIVE} --target_arch=${NPM_ARCH_NATIVE} ${NPM_FLAGS_NATIVE} "$@" || die "oe_runnpm_native failed"

}
