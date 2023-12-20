;; Load env
(load "~/.emacs.d/.env.el" t)

;; User Interface
;; Get rid of scroll bar, menubar and toolbar
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Display line numbers everywhere
(global-display-line-numbers-mode)

;; Change default frame size
(setq default-frame-alist '((width . 120) (height . 80)))

;; Fonts
(set-face-attribute 'default nil :height 136)

;; No bell, no startup screen
(setq ring-bell-function 'ignore
      inhibit-startup-screen t
)

;; Disable backup files (my be not a good idea?), lock files and auto save
(setq make-backup-files nil
      create-lockfiles nil
      auto-save-default nil)

;; Fido mode everywhere, it's an improved ido mode
(fido-mode t)

;; Dired
(setq dired-create-destination-dirs 'ask)

;; Package manager
(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package straight
  :custom
  (setq straight-repository-branch "develop"
        straight-check-for-modifications 'live
        straight-use-package-version 'ensure
        straight-use-package-by-default t
        straight-recipes-gnu-elpa-use-mirror t))

;; iSearch
(use-package isearch
  :init
  (setq isearch-lazy-count t))

;; Tramp for remote editing
(use-package tramp
  :defer t
  :config
  (setq tramp-ssh-controlmaster-options
	(concat
	 "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
	 "-o ControlMaster=auto -o ControlPersist=yes"))
  (setq tramp-verbose 7)
  (setq vc-handled-backends '(Git)))

;; Autorevert files and other stuff like dired
(use-package autorevert 
  :init (global-auto-revert-mode)
  :config
  (setq global-auto-revert-non-file-buffers t))

;; Project.el for project management
(use-package project
  :ensure t)

;; Install packages
(use-package markdown-mode
  :ensure t)

;; Initialize C-3PO only if the key is available.
(if (boundp 'OPENAI_API_KEY)
    (use-package c3po
      :straight (:host github :repo "d1egoaz/c3po.el")
      :config
      (setq c3po-api-key OPENAI_API_KEY))
  ())

;; Using LSP
(use-package eglot
  :ensure t
  :init
  :hook
  ((python-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode) . eglot-ensure))

;; Auto Completion
(use-package corfu  
  :ensure t
  :custom  
  (corfu-auto t) 
  (corfu-auto-delay 1)
  :init
  (global-corfu-mode))

;; Need corfu-terminal to get auto-complete working in terminal
(use-package corfu-terminal
  :ensure t)

(unless (display-graphic-p)
  (corfu-terminal-mode +1))

;; Make sure to detect correct python env
(use-package pet
  :straight (:host github :repo "wyuenho/emacs-pet")
  :ensure t
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

;; Js
(setq js-indent-level 2)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; Org mode
(use-package org
  :straight (:type built-in)
  :ensure t
  :config
  (setq org-agenda-files '("~/org"))
  (setq org-default-notes-file '("~/org/tasks.org"))
  (setq org-log-into-drawer t)
  (setq org-log-done 'time)
  (setq org-return-follows-link  t)
  (setq org-hide-emphasis-markers t)

  (setq org-habit-show-habits-only-for-today nil)
  
  (setq org-agenda-repeating-timestamp-show-all nil)
  (setq org-agenda-include-diary t)
  (setq org-agenda-sorting-strategy
      '((agenda time-up habit-down priority-down category-keep)	
        (todo priority-down category-keep)
        (tags priority-down category-keep)
        (search category-keep)))

  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook 'visual-line-mode)
  
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (define-key global-map "\C-cc" 'org-capture)

  (use-package org-contrib
    :ensure t)
)

;; Map to new treesitter modes
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
      '((js-mode . js-ts-mode)
	(js-json-mode . json-ts-mode)
	(typescript-mode . typescript-ts-mode)
	(python-mode . python-ts-mode)))

;; Auto mapping from file extention
(add-to-list 'auto-mode-alist '("\\.[jt]sx?\\'" . tsx-ts-mode))

;; Load theme
(load-theme 'deeper-blue t)

;; Load custom files
(load-file(locate-user-emacs-file "custom/compile-ts.el"))

