inherit npm-base

B="${S}"

NPM_INSTALL ?= ""
NPM_INSTALL_FLAGS ?= ""

do_npm_install() {
	cd ${S}
	oe_runnpm ${NPM_INSTALL_FLAGS} install ${NPM_INSTALL}
}

do_npm_shrinkwrap() {
	cd ${S}
	oe_runnpm shrinkwrap
}

do_npm_dedupe() {
	cd ${S}
	oe_runnpm dedupe
}

#
# npm causes unavoidable host-user-contaminated QA warnings for debug packages
#
INSANE_SKIP_${PN}-dbg += " host-user-contaminated"

addtask npm_install after do_compile before do_npm_dedupe
addtask npm_shrinkwrap after do_npm_install before do_npm_dedupe
addtask npm_dedupe after do_npm_shrinkwrap before do_install
