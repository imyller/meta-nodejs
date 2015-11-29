DEPENDS += " node-native"

RDEPENDS_${PN} += " node"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM ?= "npm"
NPM_CACHE_DIR = "${WORKDIR}/npm_cache"
NPM_ARCH ?= "${TARGET_ARCH}"
NPM_LD ?= "${CXX}"
NPM_FLAGS ?= ""

# Target npm

oe_runnpm() {

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR}"

	[ -n "${http_proxy}" ] && export NPM_CONFIG_PROXY="${http_proxy}"
	[ -n "${https_proxy}" ] && export NPM_CONFIG_HTTPS_PROXY="${https_proxy}"
	[ -n "${HTTP_PROXY}" ] && export NPM_CONFIG_PROXY="${HTTP_PROXY}"
	[ -n "${HTTPS_PROXY}" ] && export NPM_CONFIG_HTTPS_PROXY="${HTTPS_PROXY}"

	bbnote NPM target architecture: ${NPM_ARCH}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM HTTP proxy: ${NPM_CONFIG_PROXY}
	bbnote NPM HTTPS proxy: ${NPM_CONFIG_HTTPS_PROXY}

	bbnote ${NPM} --arch=${NPM_ARCH} --target_arch=${NPM_ARCH} ${NPM_FLAGS} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD}" ${NPM} --arch=${NPM_ARCH} --target_arch=${NPM_ARCH} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"

}

# Native npm

NPM_NATIVE ?= "npm"
NPM_CACHE_DIR_NATIVE = "${WORKDIR}/npm_cache"
NPM_ARCH_NATIVE ?= "${BUILD_ARCH}"
NPM_LD_NATIVE ?= "${BUILD_CXX}"
NPM_FLAGS_NATIVE ?= ""

oe_runnpm_native() {

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR_NATIVE}"

	[ -n "${http_proxy}" ] && export NPM_CONFIG_PROXY="${http_proxy}"
	[ -n "${https_proxy}" ] && export NPM_CONFIG_HTTPS_PROXY="${https_proxy}"
	[ -n "${HTTP_PROXY}" ] && export NPM_CONFIG_PROXY="${HTTP_PROXY}"
	[ -n "${HTTPS_PROXY}" ] && export NPM_CONFIG_HTTPS_PROXY="${HTTPS_PROXY}"

	bbnote NPM native architecture: ${NPM_ARCH_NATIVE}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM HTTP proxy: ${NPM_CONFIG_PROXY}
	bbnote NPM HTTPS proxy: ${NPM_CONFIG_HTTPS_PROXY}

	bbnote ${NPM_NATIVE} --arch=${NPM_ARCH_NATIVE} --target_arch=${NPM_ARCH_NATIVE} ${NPM_FLAGS_NATIVE} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD_NATIVE}" ${NPM_NATIVE} --arch=${NPM_ARCH_NATIVE} --target_arch=${NPM_ARCH_NATIVE} ${NPM_FLAGS_NATIVE} "$@" || die "oe_runnpm_native failed"

}
