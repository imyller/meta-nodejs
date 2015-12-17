SUMMARY = "Grunt.js command line wrapper"
HOMEPAGE = "http://gruntjs.com/"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE-MIT;md5=d61056bfad54e10504adf913ab74eb18"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/gruntjs/grunt-cli/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "96c13b018da56d1c822fa432a4110820"
SRC_URI[sha256sum] = "bb291c97f5ac5dc3f549343436f64ff066a0138565e15c794b1636d37fdc4992"

inherit npm-install-global

BBCLASSEXTEND = "native nativesdk"
