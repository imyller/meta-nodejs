inherit npm

B="${S}"

DEPENDS += " node-native gulp-native"

GULP ?= "gulp"
GULP_TARGET ?= ""

oe_rungulp() {
	bbnote ${GRUNT} --verbose "$@"

	${GULP} --verbose "$@" || die "oe_rungulp failed"
}

do_configure() {
	oe_runnpm ${NPM_INSTALL_FLAGS} install
}

do_compile() {
	oe_rungulp ${GULP_TARGET}
}
