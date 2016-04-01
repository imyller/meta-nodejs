DEPENDS += " bower-native"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

BOWER ?= "bower"
BOWER_FLAGS ?= ""

BOWER_REGISTRY ?= "https://bower.herokuapp.com"

# Target bower

oe_runbower() {

	bbnote ${BOWER} ${BOWER_FLAGS} "$@"

	export bower_storage_packages="${WORKDIR}/.bower/packages"
	export bower_storage_registry="${WORKDIR}/.bower/registry"
	export bower_storage_links="${WORKDIR}/.bower/links"
	export bower_registry="${BOWER_REGISTRY}"

	${BOWER} --config.color=false --config.interactive=false ${BOWER_FLAGS} "$@" || die "oe_runbower failed"

}
