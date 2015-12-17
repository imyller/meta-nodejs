inherit npm

B="${S}"

DEPENDS += " node-native grunt-cli-native"

GRUNT ?= "grunt"
GRUNT_TARGET ?= ""

oe_rungrunt() {
	bbnote ${GRUNT} --verbose "$@"

	${GRUNT} --verbose "$@" || die "oe_rungrunt failed"
}

do_configure() {
	oe_runnpm ${NPM_INSTALL_FLAGS} install
}

do_compile() {
	oe_rungrunt ${GRUNT_TARGET}
}
