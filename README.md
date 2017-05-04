meta-nodejs <img src="https://github.com/nodejs/nodejs.org/raw/master/static/images/logos/nodejs-new-black.png" width="128" align="right">
===========

OpenEmbedded layer for latest [Node.js](https://nodejs.org/ "Node.js") releases.
 
:information_source: *As an official extension of this layer, installing [`meta-nodejs-contrib`](https://github.com/imyller/meta-nodejs-contrib) is highly recommended for community contributed Node.js based package recipes and Bitbake helper classes.*

## Node.js releases

 * ![Current 7](https://img.shields.io/badge/Node.js%20Current-7.10.0-green.svg)
 * ![LTS 6](https://img.shields.io/badge/Node.js%20LTS-6.10.3-blue.svg)
 * ![Maintenance 4](https://img.shields.io/badge/Node.js%20Maintenance-4.8.3-B0C4DE.svg)
 * ![End of life 0.12](https://img.shields.io/badge/Node.js%20End%20of%20Life-0.12.18-lightgray.svg)
 * ![End of life 0.10](https://img.shields.io/badge/Node.js%20End%20of%20Life-0.10.48-lightgray.svg)
 * ![End of life 0.8](https://img.shields.io/badge/Node.js%20End%20of%20Life-0.8.28-lightgrey.svg)

![LTS Schedule](https://github.com/nodejs/LTS/raw/master/schedule.png)

## Dependencies

`meta-nodejs` depends on following layers:

 * [`openembedded-core`](http://layers.openembedded.org/layerindex/branch/master/layer/openembedded-core/)

### Cross-compiling for 32-bit target on 64-bit host

Node.js v7+ ships with V8 v5.5+ that requires native (host) compilation of some internal build tools (`mkpeephole` and `mksnapshot`).
These internal tools must be built with "bitness" matching the cross-compilation target (eg. 32-bit ARM).

If you encounter build errors related to `mkpeephole` or `mksnapshot` you most likely need to install appropriate multilib compilers and libraries to to your host system.

#### Example

Prerequisites for compiling for 32-bit ARM with x86_64 Ubuntu 16.04 Xenial (or newer):

```
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install g++-multilib libssl-dev:i386 libcrypto++-dev:i386 zlib1g-dev:i386
```

## Available Packages

 * `nodejs`
 * `nodejs-npm`
 * `nodejs-dtrace`
 * `nodejs-systemtap`
 * `nodejs-wafadmin` (only with Node.js `0.8`)

Installation
============

Layer installation varies depending on your OpenEmbedded distribution. These instructions are generic.

1. Fetch `meta-nodejs` layer from `https://github.com/imyller/meta-nodejs.git`
	
2. Add `meta-nodejs` layer to `EXTRALAYERS` in `conf/bblayers.conf`. For example:

	```bitbake
		EXTRALAYERS +=" \
			${TOPDIR}/sources/meta-nodejs \
		"
	```
	
## Recommended layers

As an official extension of this layer, installing [`meta-nodejs-contrib`](https://github.com/imyller/meta-nodejs-contrib) is highly recommended for community contributed Node.js based package recipes and Bitbake helper classes.

Usage
=====

### Building Node Packages

To build latest stable Node.js package:

```shell
	bitbake nodejs
```

### Node.js as a dependency

Add Node.js as a dependency in recipe with `RDEPENDS` (for runtime) or `DEPENDS` (for build):

```bitbake
	DEPENDS += " nodejs"
	RDEPENDS_${PN} += " nodejs"
```

### `npm install` buildable recipes

Inherit `npm-install` build task class in your recipe.

Bitbake classes 
===============

`meta-nodejs` layer adds few Node.js related helper classes.

## `npm-base` class

`npm-base` class defines following functions:
 
  * `oe_runnpm`: call cross-compiling `npm`
  * `oe_runnpm_native`: call native-compiling `npm`
  
For example:

```bitbake
  inherit npm-base

  do_install() {
	oe_runnpm install     # Installs dependencies defined in package.json
  }
```

### Variables

 * `NPM_FLAGS`: Extra command line arguments for `npm` calls made by `oe_runnpm()`
 * `NPM_ARCH`: Override npm target architecture (defaults to `TARGET_ARCH`)
 * `NPM_REGISTRY`: override npm registry URL

## `npm-install` class

`npm-install` class inherits `npm-base` class and adds following build tasks (listed in their run order):

  * `npm_install`: runs `npm install` in source directory
  * `npm_shrinkwrap`: runs `npm shrinkwrap` in source directory
  * `npm_dedupe`: runs `npm dedupe` in source directory

You can disable one or more of these build tasks in the recipe with `do_<taskname>[noexec] = "1"`:

```bitbake
  do_npm_shrinkwrap[noexec] = "1"
```

### Variables

 * `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `npm_install` task 
 * `NPM_INSTALL`: Parameters for `npm install` command (such as specific package names)

## `npm-install-global` class

`npm-install-global` class inherits `npm-base` class and installs the selected package globally.
This is done in the `do_install` task of the class.

### Variables

* `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `do_install` and `do_configure` task
