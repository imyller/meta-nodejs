DEPENDS += " virtual/node-native"

RDEPENDS_${PN} += " node"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

NPM = "npm"
NPM_CACHE_DIR = "${WORKDIR}/npm_cache"

NPM_ARCH ?= "${TARGET_ARCH}"
NPM_FLAGS ?= ""	

CCACHE = ""

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

	LD="${CXX}" ${NPM} --arch=${NPM_ARCH} --target_arch=${NPM_ARCH} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"

}
