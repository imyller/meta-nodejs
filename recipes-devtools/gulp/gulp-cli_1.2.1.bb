SUMMARY = "Command line interface for the Gulp streaming build system"
HOMEPAGE = "http://gulpjs.com/"
SECTION = "js/devel"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://LICENSE;md5=2823b4b2f2e0f9bae5fa46f1f150c75a"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/gulpjs/gulp-cli/archive/v${PV}.tar.gz"
SRC_URI[md5sum] = "8df6f0d0d5ffba55446c5aa480822cf0"
SRC_URI[sha256sum] = "7269e87c54bbc65a13bb031567e5281902a64cfb6dc9810ed450316cded8fad4"

INSANE_SKIP_${PN} += "file-rdeps"

inherit npm-install-global

BBCLASSEXTEND = "native nativesdk"
