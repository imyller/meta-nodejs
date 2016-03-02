meta-nodejs
===========

OpenEmbedded layer for latest stable [Node.js](https://nodejs.org/ "Node.js") releases. 

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=imyller&url=https://github.com/imyller/meta-nodejs&title=meta-nodejs&language=&tags=github&category=software)

## Node.js versions

Stable releases of Node.js:
 * `5.7`
 * `5.6`
 * `5.5`
 * `5.4`
 * `5.3`
 * `5.2`
 * `5.1`
 * `5.0`
 * `4.3` (LTS)
 * `4.2`
 * `4.1`
 * `4.0`
 * `0.12` (LTS)
 * `0.10`
 * `0.8`

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

## `npm-global-install` class

`npm-global-install` class inherits `npm` class and installs the selected package globally.
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

It defines the following functions:

  * `oe_rungulp`: call `gulp`

### Variables

* `NPM_INSTALL_FLAGS`: Extra command line arguments for `npm` calls made in `do_configure` task
* `GULP_TARGET`: The gulp target to run. (default: "")
