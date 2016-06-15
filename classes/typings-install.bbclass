inherit typings

TYPINGS_INSTALL ?= ""
TYPINGS_INSTALL_FLAGS ?= ""

do_typings_install() {
	cd ${S}
	oe_runtypings ${TYPINGS_INSTALL_FLAGS} install ${TYPINGS_INSTALL}
}

addtask typings_install after do_configure before do_compile
