DEPENDS += " typings-native"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

TYPINGS ?= "typings"
TYPINGS_FLAGS ?= ""

# Target typings

oe_runtypings() {

	bbnote ${TYPINGS} ${TYPINGS_FLAGS} "$@"

	${TYPINGS} ${TYPINGS_FLAGS} "$@" || die "oe_runtypings failed"

}
