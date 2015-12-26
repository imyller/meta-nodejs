DEPENDS += " bower"

RDEPENDS_${PN} += " node"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

BOWER ?= "bower"
BOWER_FLAGS ?= ""

# Target bower

oe_runbower() {

	bbnote ${BOWER} ${BOWER_FLAGS} "$@"

	${BOWER} ${BOWER_FLAGS} "$@" || die "oe_runbower failed"

}
