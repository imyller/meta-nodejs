SUMMARY = "Gulp command line wrapper"
HOMEPAGE = "http://gulpjs.com/"
SECTION = "js/devel"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://LICENSE;md5=b38c19ffc6b9c9f76c84b968b92c8a6d"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/gulpjs/gulp/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "f22463b631e15d674974435af5b8bc59"
SRC_URI[sha256sum] = "9616c6bc8ca165375832bdc096260931369d5339edef2e0a4d48bc7a05b04d15"

INSANE_SKIP_${PN} += "file-rdeps"

inherit npm-install-global

BBCLASSEXTEND = "native nativesdk"
