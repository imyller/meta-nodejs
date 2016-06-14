require nodejs_0.inc

INC_PR = "r4"

LIC_FILES_CHKSUM = "file://LICENSE;md5=95a589a3257ab7dfe37d8a8379e3c72d"

SRC_URI[md5sum] = "2516e11b2cb231b122c0bf37a78ed4b0"
SRC_URI[sha256sum] = "50e9a4282a741c923bd41c3ebb76698edbd7b1324024fe70cedc1e34b782d44f"

PACKAGES =+ "${PN}-wafadmin"
FILES_${PN}-wafadmin = "${exec_prefix}/lib/node/wafadmin"
