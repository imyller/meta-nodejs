inherit npm-base

B="${S}"

DEPENDS += "\
  node-native \
  gulp-cli-native \
"

GULP ?= "gulp"
GULP_TASKS ?= ""
GULP_OPTIONS ?= ""

oe_rungulp() {
	bbnote ${GULP} "$@" -LLLL

	${GULP} "$@" -LLLL || die "oe_rungulp failed"
}

do_configure() {
	oe_runnpm ${NPM_INSTALL_FLAGS} install

	# install gulp separately.  Typically gulp is a part of
	# devDependencies but in the context of Yocto there is a good
	# chance we might want to avoid other devDependencies but still
	# be able to use gulp.
	oe_runnpm ${NPM_INSTALL_FLAGS} install gulp
}

do_compile() {
	oe_rungulp ${GULP_TASKS} ${GULP_OPTIONS}
}
