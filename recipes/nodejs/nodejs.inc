DESCRIPTION = "Node.js is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications."
HOMEPAGE = "http://nodejs.org"

INC_PR ?= "r0"

PR = "${INC_PR}.0"

DEPENDS = "openssl"

PROVIDES = "virtual/node"
RPROVIDES_${PN} = "node"
RCONFLICTS_${PN} = "iojs"

SRC_URI = "http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

S = "${WORKDIR}/node-v${PV}"

# v8 errors out if you have set CCACHE
CCACHE = ""

def map_dest_cpu(target_arch, d):
    import re
    if   re.match('p(pc|owerpc)(|64)', target_arch): return 'ppc'
    elif re.match('i.86$', target_arch): return 'ia32'
    elif re.match('x86_64$', target_arch): return 'x64'
    elif re.match('arm64$', target_arch): return 'arm'
    return target_arch

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)}"
ARCHFLAGS ?= ""

GYP_DEFINES_append_mipsel = " mips_arch_variant='r1' "

do_configure () {
  export LD="${CXX}"
  alias g++="${CXX}"
  GYP_DEFINES="${GYP_DEFINES}" export GYP_DEFINES
  ./configure 	--prefix="${prefix}" \
		--without-snapshot --shared-openssl \
		--dest-cpu="${@map_dest_cpu(d.getVar('TARGET_ARCH', True), d)}" \
	 	--dest-os=linux ${ARCHFLAGS}
  unalias g++
}

do_compile () {
  export LD="${CXX}"
  alias g++="${CXX}"
  make BUILDTYPE=Release
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
