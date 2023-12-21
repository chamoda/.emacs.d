;; Load env
(load "~/.emacs.d/.env.el" t)

;; User Interface
;; Get rid of scroll bar, menubar and toolbar
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

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

;; Package manager

;; Ensure packages
(setq use-package-always-ensure t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Support installing from git
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

;; Dired
(use-package dired
  :ensure nil
  :init
  (setq dired-create-destination-dirs 'ask)
  )

;; iSearch
(use-package isearch
  :ensure nil
  :init
  (setq isearch-lazy-count t))

;; Tramp for remote editing
(use-package tramp
  :init
  (setq tramp-ssh-controlmaster-options
	(concat
	 "-o ControlPath=/tmp/ssh-ControlPath-%%r@%%h:%%p "
	 "-o ControlMaster=auto -o ControlPersist=yes"))
  (setq tramp-verbose 7)
  (setq vc-handled-backends '(Git)))

;; Autorevert files and other stuff like dired
(use-package autorevert 
  :init
  (setq global-auto-revert-non-file-buffers t)
  :custom
  (global-auto-revert-mode))

;; Project.el for project management
(use-package project)

(use-package c3po
  :when (boundp 'OPENAI_API_KEY)
  :vc (:fetcher github :repo "d1egoaz/c3po.el")      
  :init
  (setq c3po-api-key OPENAI_API_KEY))

;; Using LSP
(use-package eglot
  :hook
  ((python-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode) . eglot-ensure))

;; Auto Completion
(use-package corfu
  :custom  
  (corfu-auto t) 
  (corfu-auto-delay 1)
  :init
  (global-corfu-mode))

;; Need corfu-terminal to get auto-complete working in terminal
(use-package corfu-terminal
  :custom
  (unless (display-graphic-p)
    (corfu-terminal-mode +1))
  )

;; Make sure to detect correct python env
(use-package pet
  :init
  (add-hook 'python-base-mode-hook 'pet-mode -10))

;; Org mode
(use-package org
  :init
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
  :hook 
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode))
  :bind
  (
   ("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   )
  :custom
  (use-package org-contrib))

;; Install lang support

;; Javascript
(use-package js
  :config
  (setq js-indent-level 2)
  )

;; Markdown
(use-package markdown-mode)

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

