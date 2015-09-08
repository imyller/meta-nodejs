INC_PR = "r2"

LICENSE = "MIT & BSD"

require nodejs0.inc

PACKAGES =+ "${PN}-wafadmin"
FILES_${PN}-wafadmin = "${libdir}/node/wafadmin"
