;; -*- coding: utf-8; lexical-binding: t -*-

;; Load env
(load "~/.emacs.d/.env.el" t)

;; Change default frame size
(setq default-frame-alist '((width . 120) (height . 60)))

;; Fonts
(set-face-attribute 'default nil :height 160)

;; Tab width
(setq-default tab-width 4)

;; No bell, no startup screen
(setq ring-bell-function 'ignore
      inhibit-startup-screen t
      )

;; Disable backup files, lock files and auto save
(setq make-backup-files nil
      create-lockfiles nil
      auto-save-default nil)

;; Package manager
(package-initialize)

;; Ensure packages
(setq use-package-always-ensure t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Support installing from git
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

;; Dired
(use-package dired
  :ensure nil
  :init
  (setq dired-create-destination-dirs 'ask))

;; iSearch
(use-package isearch
  :ensure nil
  :init
  (setq isearch-lazy-count t)
  (setq case-fold-search t)
  (setq search-whitespace-regexp ".*?")
  )

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
  :config
  (global-auto-revert-mode))

;; Project.el for project management
(use-package project
  :custom
  (project-switch-commands 'project-find-file))

;; Offline documentation
(use-package devdocs
  :init
  (setq shr-use-fonts nil))


;; Vertico
(use-package vertico
  :init
  (vertico-mode))

;; Persist history over restarts.
(use-package savehist
  :init
  (savehist-mode))

;; Orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; marginilia
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; Show next key
(use-package which-key
  :init
  (which-key-mode)
  (setq which-key-idle-delay 0.8))


;; Consult
(use-package consult
  :bind (("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command) 
         ("C-x b" . consult-buffer)                
         ("C-x 4 b" . consult-buffer-other-window) 
         ("C-x 5 b" . consult-buffer-other-frame)  
         ("C-x t b" . consult-buffer-other-tab)    
         ("C-x r b" . consult-bookmark)            
         ("C-x p b" . consult-project-buffer)      
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)         
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)                
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               
         ("M-g g" . consult-goto-line)             
         ("M-g M-g" . consult-goto-line)           
         ("M-g o" . consult-outline)               
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)                  
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
		 
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         
         ("M-s e" . consult-isearch-history)       
         ("M-s l" . consult-line)                  
         ("M-s L" . consult-line-multi)            
		 
         :map minibuffer-local-map
         ("M-s" . consult-history)                 
         ("M-r" . consult-history))                

  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  (advice-add #'register-preview :override #'consult-register-window)

  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any))
  )

;; Editor config
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Using LSP
(use-package eglot
  :init
  (setq eglot-autoshutdown t)
  (setq eglot-confirm-server-initiated-edits nil)
  :hook
  ((python-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode go-ts-mode) . eglot-ensure))

;; LSP performance improvements
(setq eldoc-idle-delay 0.5)
(setq flymake-no-changes-timeout 2)
(setq eldoc-echo-area-prefer-doc-buffer t)
(fset #'jsonrpc--log-event #'ignore)
(setq eglot-events-buffer-size 0)
(setq eglot-sync-connect nil)
(setq eglot-connect-timeout nil)
(setq eglot-send-changes-idle-time 0.75)

;; Garbage collector
(use-package gcmh
  :init
  (setq gcmh-high-cons-threshold 536870912) ;; 512MB
  (setq gcmh-verbose t)
  (gcmh-mode 1))

;; Auto Completion
(global-set-key [remap dabbrev-expand] 'dabbrev-expand)
(use-package corfu
  :custom  
  (corfu-auto t)
  (corfu-auto-delay 0.10)
  (corfu-auto-prefix 1)
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode))

;; Need corfu-terminal to get auto-complete working in terminal
(use-package corfu-terminal
  :custom
  (unless (display-graphic-p)
    (corfu-terminal-mode +1))
  )

;; Multiple cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Org mode
(use-package org
  :init
  (setq org-agenda-files '("~/org"))
  (setq org-default-notes-file '("~/org/tasks.org"))
  (setq org-log-into-drawer t)
  (setq org-log-done 'time)
  (setq org-cycle-separator-lines 0)
  (setq org-startup-folded t)
  (setq org-return-follows-link  t)
  (setq org-hide-emphasis-markers t)
  (setq org-use-speed-commands t)
  
  (setq org-habit-show-habits-only-for-today nil)
  
  (setq org-agenda-repeating-timestamp-show-all nil)
  (setq org-agenda-include-diary t)
  (setq org-agenda-sorting-strategy
		'((agenda time-up habit-down priority-down category-keep)	
          (todo priority-down category-keep)
          (tags priority-down category-keep)
          (search category-keep)))
  (print org-format-latex-options)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 3.0))
  (set-default 'preview-scale-function 1.2)
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width nil)
  (setq org-confirm-babel-evaluate nil)
  
  :hook 
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode)
   (org-mode . turn-on-flyspell))
  :bind
  (
   ("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   )
  :config
  (use-package org-contrib) ;; this is not running?
  (use-package ob-mermaid)
  (require 'org-checklist)
  (require 'org-tempo)

  (setq org-babel-python-command "python3")
  
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)(shell . t)(mermaid . t)))
  (add-to-list 'org-modules 'org-tempo t)
  (add-to-list 'org-modules 'org-checklist t)

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

;; Install lang support
(add-to-list 'safe-local-variable-values '(indent-tabs-mode . nil))

;; Fix tab isssue in tsx-ts-mode
(add-hook 'tsx-ts-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

;; Markdown
(use-package markdown-mode)

;; Set treesitter modes automatically
(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

;; Javascript
(use-package js
  :config
  (setq js-indent-level 2))

(add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mdx\\'" . markdown-mode))

;; Python
;; Make sure to detect correct python env
(use-package pet
  :init
  (add-hook 'python-base-mode-hook 'pet-mode -10))
;; For jinja template support
(use-package jinja2-mode)

;; Golang
(use-package go-ts-mode
  :init
  (setq go-ts-mode-indent-offset 4))

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . go-mod-ts-mode))

(defun eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))

(add-hook 'go-ts-mode-hook #'eglot-format-buffer-on-save)

;; Spelling and grammar
(use-package languagetool
  :init
  (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
		languagetool-suggestion-level "PICKY"
		languagetool-mother-tongue "en-US"
		languagetool-correction-language "en-US"
		languagetool-console-command "~/.languagetool/languagetool-commandline.jar"
		languagetool-server-command "~/.languagetool/languagetool-server.jar")
  )

;; Templates
(use-package yasnippet
  :init
  (yas-global-mode 1))

;; Theme
(use-package gruber-darker-theme)
(load-theme 'gruber-darker t)
(add-to-list 'default-frame-alist `(font . ,"Iosevka"))

;; User Interface
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
