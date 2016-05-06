DESCRIPTION = "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE = "http://nodejs.org"

LICENSE = "MIT"

INC_PR = "r1"
PR = "${INC_PR}.2"

PROVIDES = "node"
RPROVIDES_${PN} = "node"

SRC_URI = "https://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz;name=src"

S = "${WORKDIR}/node-v${PV}"

# v8 errors out if you have set CCACHE
CCACHE = ""

inherit nodejs

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)} \
                 ${@bb.utils.contains('TUNE_FEATURES', 'neon', '--with-arm-fpu=neon', \
                    bb.utils.contains('TUNE_FEATURES', 'vfpv3d16', '--with-arm-fpu=vfpv3-d16', \
                    bb.utils.contains('TUNE_FEATURES', 'vfpv3', '--with-arm-fpu=vfpv3', \
                    '--with-arm-fpu=vfp', d), d), d)}"
ARCHFLAGS ?= ""

GYP_DEFINES_append_mipsel = " mips_arch_variant='r1' "

PACKAGECONFIG[zlib] = "--shared-zlib,,zlib"
PACKAGECONFIG[openssl] = "--shared-openssl,,openssl"

DISABLE_STATIC = ""

do_configure () {
  export LD="${CXX}"
  alias g++="${CXX}"
  GYP_DEFINES="${GYP_DEFINES}" export GYP_DEFINES
  ./configure 	--prefix="${prefix}" \
		--dest-cpu="${@nodejs_map_dest_cpu(d.getVar('TARGET_ARCH', True), d)}" \
		--dest-os=linux ${ARCHFLAGS} \
		--without-snapshot \
		${EXTRA_OECONF}
  unalias g++
}

do_compile () {
  export LD="${CXX}"
  alias g++="${CXX}"
  make ${PARALLEL_MAKE} BUILDTYPE=Release
  unalias g++
}

do_install () {
  oe_runmake DESTDIR=${D} install
}

do_install_append_class-native() {
  # make sure we use node from PATH instead of absolute path to sysroot
  sed "1s^.*^#\!/usr/bin/env node^g" -i ${D}${libdir}/node_modules/npm/bin/npm-cli.js
}

do_install_append_class-target() {
  # make sure we use node from PATH instead of absolute path to sysroot
  sed "1s^.*^#\!${bindir}/env node^g" -i ${D}${libdir}/node_modules/npm/bin/npm-cli.js
}

PACKAGES =+ "${PN}-npm"
FILES_${PN}-npm = "${libdir}/node_modules ${bindir}/npm"
RDEPENDS_${PN}-npm = "bash python-compiler python-shell python-datetime python-subprocess python-multiprocessing python-crypt python-textutils python-netclient python-misc"

PACKAGES =+ "${PN}-dtrace"
FILES_${PN}-dtrace = "${libdir}/dtrace"

PACKAGES =+ "${PN}-systemtap"
FILES_${PN}-systemtap = "${datadir}/systemtap"

BBCLASSEXTEND = "native"
