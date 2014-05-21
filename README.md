meta-nodejs
===========

OpenEmbedded layer for latest stable Node.js releases.

## Install

1. Add `meta-nodejs` layer to `sources/layers.txt`

    ```
      meta-nodejs,git://github.com/imyller/meta-nodejs.git,master,HEAD
    ```
    
2. Add `meta-nodejs` layer to `EXTRALAYERS` in `conf/bblayers.conf`

    ```
        EXTRALAYERS +=" \
            ${TOPDIR}/sources/meta-nodejs \
        "
    ```
  
3. Run `oebb.sh update`

## Usage

### Building Node.js package

1. To build latest stable Node.js package:

```
    bitbake nodejs
```

### Node.js runtime as a dependency

Add Node.js as a dependency in recipe:

```
    RDEPENDS_${PN} += "nodejs"
```

### `npm install` buildable recipes

Inherit `npm` or `npm-install` build task classes in your recipe.

## Bitbake classes 

`meta-nodejs` layer adds two new classes: `npm` and `npm-install`.

### `npm` class

`npm` defines the `oe_runnpm` command which will call cross-compiling `npm`.

For example:

```
  inherit npm
      
  do_install() {
    oe_runnpm install     # Installs dependencies defined in package.json from in source directory to node_modules
  }
```

### Variables
      
You can define extra command line arguments for `npm` calls made by `oe_runnpm()` by appending them to `NPM_FLAGS` variable.
      
### `npm-install` class

`npm-install` class inherits `npm` class and adds following build tasks (listed in their run order):

  * `npm_install`: runs `npm install` in source directory
  * `npm_shrinkwrap`: runs `npm shrinkwrap` in source directory
  * `npm_dedupe`: runs `npm dedupe` in source directory

You can disable one or more of these build tasks in the recipe with `do_<taskname>[noexec] = "1"`:

```
  do_npm_shrinkwrap[noexec] = "1"
```

#### Variables

* You can define extra command line arguments for `npm` command by appending them to `NPM_INSTALL_FLAGS` variable.

* you can define parameters for `npm install` command (such as specific package names) by appending them to `NPM_INSTALL` variable.

