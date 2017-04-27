DESCRIPTION = "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine"
HOMEPAGE = "http://nodejs.org"

LICENSE = "MIT"

COMPATIBLE_MACHINE_armv4 = "(!.*armv4).*"
# COMPATIBLE_MACHINE_armv5 = "(!.*armv5).*"
COMPATIBLE_MACHINE_mips64 = "(!.*mips64).*"

INC_PR = "r1"
PR = "${INC_PR}.8"

PROVIDES = "node"
RPROVIDES_${PN} = "node"

SRC_URI = "https://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz;name=src \
           file://no-registry_6.x.patch"

S = "${WORKDIR}/node-v${PV}"

# v8 errors out if you have set CCACHE
CCACHE = ""

inherit nodejs-arch

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)} \
                 ${@bb.utils.contains('TUNE_FEATURES', 'neon', '--with-arm-fpu=neon', \
                    bb.utils.contains('TUNE_FEATURES', 'vfpv3d16', '--with-arm-fpu=vfpv3-d16', \
                    bb.utils.contains('TUNE_FEATURES', 'vfpv3', '--with-arm-fpu=vfpv3', \
                    '--with-arm-fpu=vfp', d), d), d)}"
ARCHFLAGS ?= ""

GYP_DEFINES_append_mipsel = " mips_arch_variant='r1' "

PACKAGECONFIG ??= "zlib openssl"

PACKAGECONFIG[zlib] = "--shared-zlib,,zlib,"
PACKAGECONFIG[openssl] = "--shared-openssl,,openssl,"
PACKAGECONFIG[v8-inspector] = ",--without-inspector,,"

DISABLE_STATIC = ""

do_configure () {
  export LD="${CXX}"
  GYP_DEFINES="${GYP_DEFINES}" export GYP_DEFINES
  ./configure	--prefix="${prefix}" \
		--dest-cpu="${@nodejs_map_dest_cpu(d.getVar('TARGET_ARCH', True), d)}" \
		--dest-os=linux ${ARCHFLAGS} \
		--without-snapshot \
		--with-intl=none \
		${PACKAGECONFIG_CONFARGS}
}

do_compile () {
  export LD="${CXX}"
  oe_runmake BUILDTYPE=Release
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
