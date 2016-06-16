inherit npm-base

B="${S}"

DEPENDS += " node-native grunt-cli-native"

GRUNT ?= "grunt"
GRUNT_TARGET ?= ""
EXTRA_OEGRUNT ?= ""

oe_rungrunt() {
	bbnote ${GRUNT} ${EXTRA_OEGRUNT} --verbose "$@"

	${GRUNT} ${EXTRA_OEGRUNT} --verbose "$@" || die "oe_rungrunt failed"
}

do_configure() {
	oe_runnpm ${NPM_INSTALL_FLAGS} install
}

do_compile() {
	oe_rungrunt ${GRUNT_TARGET}
}
