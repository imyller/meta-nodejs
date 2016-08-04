DESCRIPTION = "Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications."
HOMEPAGE = "http://nodejs.org"

LICENSE = "MIT"

INC_PR ?= "r1"
PR = "${INC_PR}.7"

DEPENDS = "openssl"
DEPENDS_class-native += " openssl-native"

PROVIDES = "node"
RPROVIDES_${PN} = "node"

SRC_URI = "http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

S = "${WORKDIR}/node-v${PV}"

# v8 errors out if you have set CCACHE
CCACHE = ""

inherit nodejs-arch

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)}"
ARCHFLAGS ?= ""

GYP_DEFINES_append_mipsel = " mips_arch_variant='r1' "

do_configure () {
  export LD="${CXX}"
  alias g++="${CXX}"
  GYP_DEFINES="${GYP_DEFINES}" export GYP_DEFINES
  ./configure	--prefix="${prefix}" \
		--without-snapshot --shared-openssl \
		--dest-cpu="${@nodejs_map_dest_cpu(d.getVar('TARGET_ARCH', True), d)}" \
		--dest-os=linux ${ARCHFLAGS}
  unalias g++
}

do_compile () {
  export LD="${CXX}"
  alias g++="${CXX}"
  oe_runmake BUILDTYPE=Release
  unalias g++
}

do_install () {
  oe_runmake install DESTDIR="${D}"
}

do_install_append_class-native() {
  # make sure we use node from PATH instead of absolute path to sysroot
  sed "1s^.*^#\!/usr/bin/env node^g" -i ${D}${exec_prefix}/lib/node_modules/npm/bin/npm-cli.js
}

do_install_append_class-nativesdk() {
  # make sure we use node from PATH instead of absolute path to sysroot
  sed "1s^.*^#\!/usr/bin/env node^g" -i ${D}${exec_prefix}/lib/node_modules/npm/bin/npm-cli.js
  sed "1s^.*^#\!/usr/bin/env python^g" -i ${D}${exec_prefix}/lib/node_modules/npm/node_modules/node-gyp/gyp/samples/samples
}

do_install_append_class-target() {
  # make sure we use node from PATH instead of absolute path to sysroot
  sed "1s^.*^#\!${bindir}/env node^g" -i ${D}${exec_prefix}/lib/node_modules/npm/bin/npm-cli.js
}

PACKAGES =+ "${PN}-npm"
FILES_${PN}-npm = "${exec_prefix}/lib/node_modules ${bindir}/npm"
RDEPENDS_${PN}-npm = "bash python-compiler python-shell python-datetime python-subprocess python-multiprocessing python-crypt python-textutils python-netclient python-misc"

PACKAGES =+ "${PN}-dtrace"
FILES_${PN}-dtrace = "${exec_prefix}/lib/dtrace"

PACKAGES =+ "${PN}-systemtap"
FILES_${PN}-systemtap = "${datadir}/systemtap"

INSANE_SKIP_${PN} += "file-rdeps"
INSANE_SKIP_${PN}-dbg += "host-user-contaminated"

BBCLASSEXTEND = "native nativesdk"
