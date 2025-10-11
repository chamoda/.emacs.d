# My Emacs Config

## Overview

* 🖥️ Using [gruber-darker-theme](https://github.com/rexim/gruber-darker-theme).
* 🔤 Font [Iosevka](https://github.com/be5invis/Iosevka).

## Requirements

* Emacs 30.2 >= compiled with treesitter support.
* Intall Ioveska font.
* LSP servers for eglot.

## Build Emacs

Buling emacs from source is reccomended for fine grained control over build time performance optmizations. Here's instruction to compile from source in Ubnutu 24.04.

* Clone emacs repo with `git clone --depth 1 --branch emacs-30 git@github.com:emacs-mirror/emacs.git`
* Go to directory with `cd emacs`
* Enable development libraries with `sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources`
* Update the cache using `sudo apt update`
* Install necessary dependancies with `sudo apt build-dep -y emacs`
* Make sure extra dependancies with `sudo apt install libtree-sitter-dev`
* Generate configuration file with `./autogen.sh`
* Configure emacs with desired options `./configure --with-native-compilation --with-tree-sitter --with-modules --with-harfbuzz --with-cairo --with-threads --with-included-regex --with-mailutils --enable-link-time-optimization CFLAGS="-O2 -march=native -fomit-frame-pointer" LDFLAGS="-Wl,-O1 -Wl,--as-needed"`
* Compile with 4 cores `make -j4 bootstrap`
* Verify the version with `./src/emacs --version`
* Optionaly test by launching without any configuartion `./src/emacs -Q`
* Finally install system wide with `sudo make install`

## Post Installation

* `git clone git@github.com:chamoda/.emacs.d.git` in your home folder.
* Run `emacs`. It will take some time to initialze all packages.

## Screenshot

![screenshot](screenshot.png)

