inherit autotools pkgconfig

DEPENDS +=  "nodejs"

RDEPENDS_${PN} += " nodejs"
RDEPENDS_${PN}_virtclass-native += " python-native"

BBCLASSEXTEND = "native"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

NPM = "npm"
NPM_CACHE_DIR = "${WORKDIR}/npm_cache"
NPM_ARCHFLAGS += "--arch=${TARGET_ARCH} --target_arch=${TARGET_ARCH}"
NPM_FLAGS ?= ""	
CCACHE = ""

oe_runnpm() {
        bbnote ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@"
	bbnote NPM cache directory: ${NPM_CACHE_DIR}
        LD="${CXX}" NPM_CONFIG_CACHE="${NPM_CACHE_DIR}" ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"
}
