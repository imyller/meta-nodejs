inherit bower

B="${S}"

BOWER_INSTALL ?= ""
BOWER_INSTALL_FLAGS ?= ""

do_bower_install() {
	oe_runbower ${BOWER_INSTALL_FLAGS} install ${BOWER_INSTALL}
}

addtask bower_install after do_npm_dedupe before do_install
