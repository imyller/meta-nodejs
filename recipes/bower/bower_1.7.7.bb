SUMMARY = "Bower package manager"
HOMEPAGE = "http://bower.io"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e273de0d9430b4e4a74446f00e19ac54"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/bower/bower/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "0e5d771849b2f047dde428a1722b74ff"
SRC_URI[sha256sum] = "25ec165352f7bc1a185cabff31528fc149e666aa051edf920e1b99dcb68cbfbf"

inherit npm-install-global

INSANE_SKIP_${PN} += "file-rdeps"

BBCLASSEXTEND = "native nativesdk"
