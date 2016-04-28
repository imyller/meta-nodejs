meta-nodejs
===========

OpenEmbedded layer for latest [Node.js](https://nodejs.org/ "Node.js") releases. 

## Node.js releases

 * `6.x` (Current)
 * `5.x`
 * `4.x` (LTS)
 * `0.12.x` (Maintenance)
 * `0.10.x`
 * `0.8.x`

### Node.js Long Term Support Release Schedule

![LTS Schedule](https://github.com/nodejs/LTS/raw/master/schedule.png)

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

Inherit `npm-install` build task classes in your recipe. This will automatically add `node` to your `RDEPENDS_${PN}` and `node-native` to `DEPENDS`.

Bitbake classes 
===============

`meta-nodejs` layer adds few Node.js related helper classes.

## `npm` class

`npm` class defines following functions:
 
  * `oe_runnpm`: call cross-compiling `npm`
  * `oe_runnpm_native`: call native-compiling `npm`
  
For example:

```bitbake
  inherit npm

  do_install() {
	oe_runnpm install     # Installs dependencies defined in package.json
  }
```

### Variables

 * `NPM_FLAGS`: Extra command line arguments for `npm` calls made by `oe_runnpm()`
 * `NPM_ARCH`: Override npm target architecture (defaults to `TARGET_ARCH`)
 * `NPM_REGISTRY`: override npm registry URL

## `npm-install` class

`npm-install` class inherits `npm` class and adds following build tasks (listed in their run order):

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

`npm-install-global` class inherits `npm` class and installs the selected package globally.
This is done in the `do_install` task of the class.

### Variables

* `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `do_install` and `do_configure` task

## `grunt` class

`grunt` can build a package that is based on grunt.
First it will do an `npm install` during the `do_configure` task to make sure all
dependencies are available.
Then it runs `grunt` with the default target during the `do_compile` task.

It defines the following functions:

  * `oe_rungrunt`: call `grunt`

### Variables

* `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `do_configure` task
* `GRUNT_TARGET`: The grunt target to run. (default: "")

## `gulp` class

`gulp` can build a package that is based on gulp.
First it will do an `npm install` during the `do_configure` task to make sure all
dependencies are available.
Then it runs `gulp` with the default target during the `do_compile` task.

The project being built should have a `devDependency` on `gulp` in its `package.json`.

It defines the following functions:

  * `oe_rungulp`: call `gulp`

### Variables

* `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `do_configure` task
* `GULP_TASKS`: The gulp task(s) to run. (default: "")
* `GULP_OPTIONS`: Extra options to pass to gulp (e.g. `--production`). (default: "")

## `bower` class

`bower` is a package manager for web applications front-end dependencies: [bower.io](http://bower.io/ "bower.io")

`bower` class defines following functions:
 
  * `oe_runbower`: call `bower` command line utility
  
### Variables

 * `BOWER`: bower command line utility (default: `bower`)
 * `BOWER_FLAGS`: Extra command line arguments for `bower` calls made by `oe_runbower()`
 * `BOWER_REGISTRY`: override Bower registry URL 
 
## `bower-install` class

Suppose a web application has front-end dependencies which are listed in the file
bower.json. In this case the web application recipe can auto-install all those
dependencies during yocto build by inheriting `bower-install` class.

`bower-install` class inherits `bower` class and adds following build tasks:

  * `bower_install`: runs `bower install` in source directory after `do_npm_dedupe` and before `do_install`

Note that front-end dependencies are auto-installed into build directory. They have to be
explicitely copied into target image in `do_install` or `do_install_append`. Here is a
simple example of web application recipe with nodejs and bower dependencies:

```bitbake
SUMMARY = "simple web application with JS front-end dependencies listed in bower.json"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

SRCREV = "${AUTOREV}"

PR = "r0"
PV = "0.0.1+git${SRCPV}"

SRC_URI = "git://webapp.example.org/test.git;branch=master;protocol=ssh"

inherit bower-install

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/www/test/public
	cp -r ${S}/bower_components ${D}/www/test/public/
}

```

### Variables

 * `BOWER_INSTALL`: Parameters for `bower install` command (such as specific package names)
 * `BOWER_INSTALL_FLAGS`: Extra command line arguments for `bower` calls made in `bower_install` task 
