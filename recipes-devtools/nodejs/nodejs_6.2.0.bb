require nodejs_6.inc

INC_PR = "r1"

LIC_FILES_CHKSUM = "file://LICENSE;md5=ff28f0c5e93eb4e48a07fdfca061b006"

SRC_URI[src.md5sum] = "aec5b7ca5c16a50848fc446f936cd4ce"
SRC_URI[src.sha256sum] = "fcfd81847d78abb690aafaf46223d3b59aedc54fb200a2ab2bfd9a39ad6e94b9"

SRC_URI += " \
	https://patch-diff.githubusercontent.com/raw/nodejs/node/pull/6820.patch;patch=1;name=without-intl-patch \
	"

SRC_URI[without-intl-patch.md5sum] = "f1484f72695ca77565b95747cfc64168"
SRC_URI[without-intl-patch.sha256sum] = "d4bb2e5e69760b236ecbac04a99fc92bda62ba31fbf6fbba059cc258fddb846f"
