![banner](banner.png)

# My Emacs Config

## Features

* 🌳 [Treesitter](https://tree-sitter.github.io/tree-sitter/) support.
* 🚧 project.el for project managment.
* 🖥️ Using [gruber-darker-theme](https://github.com/rexim/gruber-darker-theme).
* 🔤 Font [Iosevka](https://github.com/be5invis/Iosevka).

## Requirements

* Emacs 29.1 >= compiled with treesitter support.
* Git required for package manager.
* LSP servers for eglot.

## Installation

* Install emacs 29.1 or higher.
* `git clone git@github.com:chamoda/.emacs.d.git` in your home folder.
* Go to `.emacs.d` and run `cp .env.example.el .env.el` and modify variables as needed.
* Run `emacs`. It will take some time to initialze all packages.
* Ones everything intialized, run `M-x treesitter-install-all-language-grammar` to install all grammar for treesitter modes.
* Intall font seperately.

## Screenshot

![screenshot](screenshot.png)

