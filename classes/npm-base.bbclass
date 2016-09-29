DEPENDS += " node-native"

inherit nodejs-arch

PACKAGE_DEBUG_SPLIT_STYLE = "debug-file-directory"

CCACHE = ""

NPM_REGISTRY ?= "https://registry.npmjs.org/"

NPM_IGNORE = "${WORKDIR}/.npmignore"

NPM ?= "npm"
NPM_CACHE_DIR = "${TMPDIR}/npm_cache/${PF}"
NPM_HOME_DIR = "${TMPDIR}/npm_home/${PF}"
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

	echo "/temp/" >> "${NPM_IGNORE}"
	echo "/pseudo/" >> "${NPM_IGNORE}"
	echo "/sstate*/" >> "${NPM_IGNORE}"
	echo "/license-destdir/" >> "${NPM_IGNORE}"
	echo "/image/" >> "${NPM_IGNORE}"
	echo "/patches/" >> "${NPM_IGNORE}"
	echo ".npmignore" >> "${NPM_IGNORE}"
	echo "/.*/" >> "${NPM_IGNORE}"

	mkdir -p "${NPM_HOME_DIR}"

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR}"
	export NPM_CONFIG_DEV="false"

	bbnote NPM target architecture: ${NPM_ARCH}
	bbnote NPM home directory: ${NPM_HOME_DIR}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}
	bbnote NPM workdir .npmignore: ${NPM_IGNORE}

	bbnote ${NPM} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	export http_proxy="${http_proxy}"
	export https_proxy="${https_proxy}"
	export no_proxy="${no_proxy}"

	export HOME="${NPM_HOME_DIR}"

	${NPM} cache clean || die "oe_runnpm failed (cache clean)"

	LD="${NPM_LD}" ${NPM} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS} "$@" || die "oe_runnpm failed (install)"

}

# Native npm

NPM_NATIVE ?= "npm"
NPM_CACHE_DIR_NATIVE = "${TMPDIR}/npm_cache_native/${PF}"
NPM_HOME_DIR_NATIVE = "${TMPDIR}/npm_home_native/${PF}"
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

	echo "/temp/" >> "${NPM_IGNORE}"
	echo "/pseudo/" >> "${NPM_IGNORE}"
	echo "/sstate*/" >> "${NPM_IGNORE}"
	echo "/license-destdir/" >> "${NPM_IGNORE}"
	echo "/image/" >> "${NPM_IGNORE}"
	echo "/patches/" >> "${NPM_IGNORE}"
	echo ".npmignore" >> "${NPM_IGNORE}"
	echo "/.*/" >> "${NPM_IGNORE}"

	mkdir -p "${NPM_HOME_DIR_NATIVE}"

	export NPM_CONFIG_CACHE="${NPM_CACHE_DIR_NATIVE}"
	export NPM_CONFIG_DEV="false"

	bbnote NPM native architecture: ${NPM_ARCH_NATIVE}
	bbnote NPM home directory: ${NPM_HOME_DIR_NATIVE}
	bbnote NPM cache directory: ${NPM_CONFIG_CACHE}
	bbnote NPM registry: ${NPM_REGISTRY}
	bbnote NPM workdir .npmignore: ${NPM_IGNORE}

	bbnote ${NPM_NATIVE} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS_NATIVE} "$@"

	export JOBS=${@oe.utils.cpu_count()}

	export http_proxy="${http_proxy}"
	export https_proxy="${https_proxy}"
	export no_proxy="${no_proxy}"

	export HOME="${NPM_HOME_DIR_NATIVE}"

	${NPM} cache clean || die "oe_runnpm_native failed (cache clean)"

	LD="${NPM_LD_NATIVE}" ${NPM_NATIVE} --registry=${NPM_REGISTRY} ${ARCH_FLAGS} ${NPM_FLAGS_NATIVE} "$@" || die "oe_runnpm_native failed (install)"

}
