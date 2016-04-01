SUMMARY = "Grunt.js command line wrapper"
HOMEPAGE = "http://gruntjs.com/"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE-MIT;md5=331c934843c71c28b2bf98046c03eb97"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/gruntjs/grunt-cli/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "dfd3443d0c612523ef4870c25058d368"
SRC_URI[sha256sum] = "c4f36b57629e8fe3d25ee312be721e85c5983af7d819c66f23b44a10faa37f76"

INSANE_SKIP_${PN} += "file-rdeps"

inherit npm-install-global

BBCLASSEXTEND = "native nativesdk"
