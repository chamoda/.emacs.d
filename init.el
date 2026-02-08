;; -*- coding: utf-8; lexical-binding: t -*-

;;; ==================================
;;; PERFORMANCE & STARTUP OPTIMIZATIONS
;;; ==================================

;; Performance optimizations for startup
(setq gc-cons-threshold most-positive-fixnum) ; 2^61 bytes
(setq gc-cons-percentage 0.6)

;; Restore after startup
(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 536870912   ; 512MB (gcmh will manage this)
          gc-cons-percentage 0.1)))

;; Garbage collector
(use-package gcmh
  :init
  (setq gcmh-high-cons-threshold 536870912) ;; 512MB
  (setq gcmh-verbose nil)
  (gcmh-mode 1))

;;; ==================================
;;; PACKAGE MANAGEMENT SETUP
;;; ==================================

;; Package management setup
(package-initialize)
(setq use-package-always-ensure t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;;; ==================================
;;; CORE EMACS SETTINGS
;;; ==================================

(use-package emacs
  :config
  (setq ring-bell-function 'ignore
        inhibit-startup-screen t
        column-number-mode t)
  (setq-default tab-width 4
                indent-tabs-mode nil)
  ;; Fonts
  (add-to-list 'default-frame-alist `(font . ,"Iosevka-17"))
  ;; User interface
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;;; ==================================
;;; UI & THEME CONFIGURATION
;;; ==================================

;; Theme
(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))

;;; ==================================
;;; FILE MANAGEMENT & BACKUP SETTINGS
;;; ==================================

;; Disable backup files, lock files and auto save
(setq make-backup-files nil
      create-lockfiles nil
      auto-save-default nil)

;; Dired
(use-package dired
  :ensure nil
  :init
  (setq dired-create-destination-dirs 'ask
        dired-mouse-drag-files t
        delete-by-moving-to-trash t)
  :bind (:map dired-mode-map
              ("<backspace>" . dired-up-directory)))

;; Autorevert files and other stuff like dired
(use-package autorevert 
  :init
  (setq global-auto-revert-non-file-buffers t)
  :config
  (global-auto-revert-mode))

;;; ==================================
;;; COMPLETION & NAVIGATION
;;; ==================================

;; Vertico
(use-package vertico
  :init
  (vertico-mode))

;; Persist history over restarts
(use-package savehist
  :init
  (setq savehist-additional-variables '(corfu-history))
  (savehist-mode))

;; Orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Auto Completion
(use-package corfu
  :custom  
  (corfu-auto t)
  (corfu-auto-delay 0.05)
  (corfu-auto-prefix 1)
  (corfu-popupinfo-delay 0.05)
  (corfu-preselect-first nil)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

;; Corfu terminal support
(use-package corfu-terminal
  :init
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

;; iSearch
(use-package isearch
  :ensure nil
  :init
  (setq isearch-lazy-count t
        case-fold-search t
        search-whitespace-regexp ".*?"))

;;; ==================================
;;; DEVELOPMENT TOOLS
;;; ==================================

;; Repeat mode
(use-package repeat
  :ensure nil
  :init (repeat-mode 1))

;; Show next key
(use-package which-key
  :init
  (which-key-mode)
  (setq which-key-idle-delay 0.8))

;; Editor config
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; LSP with Eglot
(use-package eglot
  :init
  ;; LSP performance improvements
  (setq eldoc-idle-delay 0.2
        flymake-no-changes-timeout 2
        eldoc-echo-area-prefer-doc-buffer t
        eglot-autoshutdown t
        eglot-confirm-server-initiated-edits nil
        eglot-events-buffer-size 0
        eglot-sync-connect nil
        eglot-connect-timeout nil
        eglot-send-changes-idle-time 0.25)
  (fset #'jsonrpc--log-event #'ignore)
  :config
  ;; Configure C/C++ server
  (add-to-list 'eglot-server-programs '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd")))
  :hook
  ((python-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode go-ts-mode rust-mode rust-ts-mode c-mode c-ts-mode) . eglot-ensure))

;; Project management
(use-package project
  :custom
  (project-switch-commands 'project-find-file))

;; Tramp for remote editing
(use-package tramp
  :init
  (setq tramp-ssh-controlmaster-options
        (concat
         "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
         "-o ControlMaster=auto -o ControlPersist=yes")
        tramp-verbose 1
        vc-handled-backends '(Git)))

;; Reformat buffers
(use-package reformatter)

;;; ==================================
;;; LANGUAGE-SPECIFIC CONFIGURATIONS
;;; ==================================

;; Language support
(add-to-list 'safe-local-variable-values '(indent-tabs-mode . nil))

;; Set treesitter modes automatically
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

;; CSS
(use-package css-mode
  :config
  (setq css-indent-offset 2))

;; JavaScript/TypeScript
(use-package js
  :config
  (setq js-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.mdx\\'" . markdown-mode)))

;; Fix tab issue in tsx-ts-mode
(add-hook 'tsx-ts-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

;; Python
(use-package pet
  :init
  (add-hook 'python-base-mode-hook 'pet-mode -10))

;; Jinja template support
(use-package jinja2-mode)

;; Web templating
(use-package web-mode
  :config
  (setq web-mode-markup-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.liquid\\'" . web-mode)))

;; Golang
(use-package go-ts-mode
  :init
  (setq go-ts-mode-indent-offset 4)
  :config
  (reformatter-define go-format
    :program "goimports"
    :args '("/dev/stdin"))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.mod\\'" . go-mod-ts-mode))
  :hook
  (go-ts-mode . go-format-on-save-mode))

;; YAML
(use-package yaml-ts-mode
  :init
  (setq yaml-ts-mode-indent-offset 2)
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode)))

;; C/C++
(use-package cc-mode
  :ensure nil
)

;; Rust
(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t)
  (setq rust-format-on-save t)
  :hook
  ((rust-mode rust-ts-mode) . eglot-ensure))

;; Format on save for rust-ts-mode using eglot
(add-hook 'rust-ts-mode-hook
          (lambda ()
            (setq-local rust-format-on-save t)
            (add-hook 'before-save-hook 'eglot-format-buffer nil t)))

;; Markdown
(use-package markdown-mode)

;;; ==================================
;;; ORG-MODE CONFIGURATION
;;; ==================================

;; Org mode
(use-package org
  :init
  (setq org-agenda-files '("~/org")
        org-default-notes-file "~/org/tasks.org"
        org-log-into-drawer t
        org-log-done 'time
        org-cycle-separator-lines 0
        org-startup-folded t
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-use-speed-commands t
        org-habit-show-habits-only-for-today nil
        org-agenda-repeating-timestamp-show-all nil
        org-agenda-include-diary t
        org-agenda-sorting-strategy
        '((agenda time-up habit-down priority-down category-keep)	
          (todo priority-down category-keep)
          (tags priority-down category-keep)
          (search category-keep))
        org-startup-with-inline-images t
        org-image-actual-width nil
        org-confirm-babel-evaluate nil)
  :hook 
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode)
   (org-mode . turn-on-flyspell))
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture))
  :config
  (use-package org-contrib)
  (require 'org-checklist)
  (require 'org-tempo)
  (require 'org-habit)
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map)
  
  (setq org-babel-python-command "python3")
  
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)(shell . t)))
  (add-to-list 'org-modules 'org-tempo t)
  (add-to-list 'org-modules 'org-checklist t)
  (add-to-list 'org-modules 'org-habit t)

  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images))

;; Org roam
(use-package emacsql-sqlite-builtin)
(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-complete-everywhere t)
  (org-roam-db-autosync-mode t)
  (org-roam-database-connector 'sqlite-builtin)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map ("C-M-i" . completion-at-point)))

;;; ==================================
;;; ADDITIONAL PACKAGES
;;; ==================================

;; Verb for HTTP requests
(use-package verb)

;; Multiple cursors
(use-package multiple-cursors)

;; Expand region
(use-package expand-region)

;;; ==================================
;;; GLOBAL KEYBINDINGS
;;; ==================================

;; Multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Expand region
(global-set-key (kbd "C-=") 'er/expand-region)

;;; ==================================
;;; CUSTOM FILE SETUP
;;; ==================================

;; Keep customize settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
