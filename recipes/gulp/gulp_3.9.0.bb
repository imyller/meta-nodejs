SUMMARY = "Gulp command line wrapper"
HOMEPAGE = "http://gulpjs.com/"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=56144547c46601ee8caeafc843fd99a6"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/gulpjs/gulp/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "4416063cfa4125ecf45cbf7833674d29"
SRC_URI[sha256sum] = "81679f0d462af503a71158bcee44a9ca2ae61b1e1c236b78b4edb4dc7e3296ec"

inherit npm-install-global

BBCLASSEXTEND = "native nativesdk"
