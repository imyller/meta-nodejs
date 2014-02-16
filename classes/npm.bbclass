inherit autotools pkgconfig

DEPENDS +=  "nodejs"

RDEPENDS_${PN} += " nodejs"
RDEPENDS_${PN}_virtclass-native += " python-native"

BBCLASSEXTEND = "native"
PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM = "npm"
ARCHFLAGS_NPM += " --arch=${TARGET_ARCH}"
EXTRA_NPM ?= ""	

oe_runnpm() {
        bbnote ${NPM} ${ARCHFLAGS_NPM} ${EXTRA_NPM} "$@"
        LD="${CXX}" ${NPM} ${ARCHFLAGS_NPM} ${EXTRA_NPM} "$@" || die "oe_runnpm failed"
}
	
do_npm_install() {
	oe_runnpm install
}

do_npm_shrinkwrap() {
         oe_runnpm shrinkwrap
}

do_npm_dedupe() {
	oe_runnpm dedupe	
}

addtask npm_install after do_compile before do_npm_dedupe
addtask npm_shrinkwrap after do_npm_install before do_npm_dedupe
addtask npm_dedupe after do_npm_shrinkwrap before do_install
