DEPENDS += " node-native"

inherit nodejs-arch

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM_REGISTRY ?= "https://registry.npmjs.org/"

NPM ?= "npm"
NPM_CACHE_DIR = "${WORKDIR}/npm_cache"
NPM_ARCH ?= "${@nodejs_map_dest_cpu(d.getVar('TARGET_ARCH', True), d)}"
NPM_LD ?= "${CXX}"
NPM_FLAGS ?= ""

NPM_FLAGS_append_class-nativesdk = " --unsafe-perm"

# Target npm

oe_runnpm() {

	if [ "${NPM_ARCH}" != "allarch" ]; then
		ARCH_FLAGS="--arch=${NPM_ARCH} --target_arch=${NPM_ARCH}"
	else
		ARCH_FLAGS=""
	fi

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR}"

	bbnote NPM target architecture: ${NPM_ARCH}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}

	bbnote ${NPM} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD}" ${NPM} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS} "$@" || die "oe_runnpm failed"

}

# Native npm

NPM_NATIVE ?= "npm"
NPM_CACHE_DIR_NATIVE = "${WORKDIR}/npm_cache"
NPM_ARCH_NATIVE ?= "${@nodejs_map_dest_cpu(d.getVar('BUILD_ARCH', True), d)}"
NPM_LD_NATIVE ?= "${BUILD_CXX}"
NPM_FLAGS_NATIVE ?= ""

NPM_FLAGS_NATIVE_append_class-nativesdk = " --unsafe-perm"

oe_runnpm_native() {

	if [ "${NPM_ARCH_NATIVE}" != "allarch" ]; then
                ARCH_FLAGS="--arch=${NPM_ARCH_NATIVE} --target_arch=${NPM_ARCH_NATIVE}"
        else
                ARCH_FLAGS=""
        fi

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR_NATIVE}"

	bbnote NPM native architecture: ${NPM_ARCH_NATIVE}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}

	bbnote ${NPM_NATIVE} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS_NATIVE} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	LD="${NPM_LD_NATIVE}" ${NPM_NATIVE} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS_NATIVE} "$@" || die "oe_runnpm_native failed"

}
