SUMMARY = "Typescript Definition Manager"
HOMEPAGE = "https://www.npmjs.com/package/typings"
SECTION = "js/devel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=298525826e29612d4180abda579d8430"

PACKAGE_ARCH = "all"

SRC_URI = "https://github.com/typings/typings/archive/v${PV}.tar.gz"

SRC_URI[md5sum] = "f74e07582ac548baf1e0a1d5d68d39df"
SRC_URI[sha256sum] = "7d0ef1472c594b7174bfc54f3f02e2334d6ce29694eb26302eb5f4ebe1f23472"

inherit npm-install-global

INSANE_SKIP_${PN} += "file-rdeps"

BBCLASSEXTEND = "native nativesdk"
