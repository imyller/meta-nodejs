SUMMARY = "Bower package manager"
HOMEPAGE = "http://bower.io"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e273de0d9430b4e4a74446f00e19ac54"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/bower/bower/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "d5b0e85eb23ee6721d1ba623f162c6a7"
SRC_URI[sha256sum] = "55ff05b6e86a767c04ef5bf3408438bee565862070e13ee0b327af5b76e446f8"

inherit npm-install-global

INSANE_SKIP_${PN} += "file-rdeps"

BBCLASSEXTEND = "native nativesdk"
