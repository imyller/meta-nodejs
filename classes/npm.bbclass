inherit autotools pkgconfig

DEPENDS +=  "nodejs"

RDEPENDS_${PN} += " nodejs"
RDEPENDS_${PN}_virtclass-native += " python-native"

BBCLASSEXTEND = "native"
PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM = "npm"
NPM_ARCHFLAGS += " --arch=${TARGET_ARCH}"
NPM_FLAGS ?= ""	

oe_runnpm() {
        bbnote ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@"
        LD="${CXX}" ${NPM} ${NPM_ARCHFLAGS} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"
}

NPM_INSTALL_FLAGS ?= ""           
NPM_INSTALL ?= ""
	
do_npm_install() {
	oe_runnpm ${NPM_INSTALL_FLAGS} install ${NPM_INSTALL} 
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
