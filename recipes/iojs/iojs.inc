DESCRIPTION = "io.js is a JavaScript platform built on Chrome's V8 runtime."

HOMEPAGE = "http://iojs.org"
LICENSE = "MIT & BSD & Apache-2.0"

INC_PR = "r1"
PR = "${INC_PR}.0"

DEPENDS = "zlib openssl"

SRC_URI = "https://iojs.org/dist/v${PV}/iojs-v${PV}.tar.gz"

S = "${WORKDIR}/iojs-v${PV}"

INSANE_SKIP_${PN} += "file-rdeps"

# v8 errors out if you have set CCACHE
CCACHE = ""

ARCHFLAGS_arm = "${@bb.utils.contains('TUNE_FEATURES', 'callconvention-hard', '--with-arm-float-abi=hard', '--with-arm-float-abi=softfp', d)}"
ARCHFLAGS_arm += " --dest-cpu=arm"
ARCHFLAGS ?= ""

do_configure () {
  export LD="${CXX}"
  alias g++="${CXX}"
  ./configure --prefix=${prefix} --without-snapshot --shared-zlib --shared-openssl --dest-os=linux ${ARCHFLAGS}
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

PROVIDES = "node"

RPROVIDES_${PN} = "node"

RCONFLICTS_${PN} = "nodejs"

RDEPENDS_${PN} = "zlib openssl curl python-compiler python-shell python-datetime python-subprocess python-multiprocessing python-crypt python-textutils python-netclient python-misc"

RDEPENDS_${PN}_virtclass-native = "curl-native python-native"
BBCLASSEXTEND = "native"

FILES_${PN} += "${libdir}/node/wafadmin ${libdir}/node_modules ${libdir}/dtrace ${datadir}/systemtap"
