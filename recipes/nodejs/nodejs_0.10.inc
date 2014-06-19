DESCRIPTION = "nodeJS Evented I/O for V8 JavaScript"
HOMEPAGE = "http://nodejs.org"
LICENSE = "MIT & BSD & Apache-2.0"

PR = "r1"

DEPENDS = "zlib openssl"

SRC_URI = "http://nodejs.org/dist/v${PV}/node-v${PV}.tar.gz"

S = "${WORKDIR}/node-v${PV}"

# v8 errors out if you have set CCACHE
CCACHE = ""

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)}"
ARCHFLAGS ?= ""

# Node is way too cool to use proper autotools, so we install two wrappers to forcefully inject proper arch cflags to workaround gypi
do_configure () {
  export LD="${CXX}"

  ./configure --prefix=${prefix} --without-snapshot --shared-zlib --shared-openssl ${ARCHFLAGS}
}

do_compile () {
  export LD="${CXX}"
  make BUILDTYPE=Release
}

do_install () {
  DESTDIR=${D} oe_runmake install
}

RDEPENDS_${PN} = "zlib openssl curl python-compiler python-shell python-datetime python-subprocess python-multiprocessing python-crypt python-textutils python-netclient python-misc"
RDEPENDS_${PN}_virtclass-native = "curl-native python-native"

FILES_${PN} += "${libdir}/node/wafadmin ${libdir}/node_modules ${libdir}/dtrace"
BBCLASSEXTEND = "native"
