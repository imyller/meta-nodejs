SUMMARY = "Bower package manager"
HOMEPAGE = "http://bower.io"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=135697567327f92e904ef0be2082da5e"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/bower/bower/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "01ad5587621e5611ec3dbdc4955cf81b"
SRC_URI[sha256sum] = "39f471dde25bcce9af9ab4d59d971ab1dffff02a0ebae03fde7a644d49326a6a"

inherit npm-install-global

RDEPENDS_${PN} += " bash"
