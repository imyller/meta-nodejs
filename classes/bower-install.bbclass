inherit bower

BOWER_INSTALL ?= ""
BOWER_INSTALL_FLAGS ?= ""

do_bower_install() {
	cd ${S}
	oe_runbower ${BOWER_INSTALL_FLAGS} install ${BOWER_INSTALL}
}

addtask bower_install after do_configure before do_compile
