inherit autotools pkgconfig

DEPENDS +=  "nodejs"

RDEPENDS_${PN} += " nodejs"
RDEPENDS_${PN}_virtclass-native += " python-native"

BBCLASSEXTEND = "native"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

NPM = "npm"
NPM_ARCHFLAGS += "--arch=${TARGET_ARCH}"
NPM_FLAGS ?= ""	
CCACHE = ""

oe_runnpm() {
        bbnote ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@"
        LD="${CXX}" ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"
}

python () {
        import npm
        bb.fetch2.methods.append( npm.NPM() )
}
