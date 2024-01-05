;; Load env
(load "~/.emacs.d/.env.el" t)

;; Change default frame size
(setq default-frame-alist '((width . 120) (height . 80)))

;; Fonts
(set-face-attribute 'default nil :height 142)

;; No bell, no startup screen
(setq ring-bell-function 'ignore
      inhibit-startup-screen t
      )

;; Disable backup files (my be not a good idea?), lock files and auto save
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
  :config
  (global-auto-revert-mode))

;; Project.el for project management
(use-package project
  :custom
  (project-switch-commands 'project-find-file))

;; AI
(use-package gptel
 :when (boundp 'OPENAI_API_KEY)
 :config
 (setq gptel-api-key OPENAI_API_KEY)
 :bind
 (("C-c RET" . gptel-send)))

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

; Trying out consult
(use-package consult
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

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

;; Version control
;; Magit
(use-package magit)

;; Using LSP
(use-package eglot
  :hook
  ((python-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode) . eglot-ensure))

;; Auto Completion
(global-set-key [remap dabbrev-expand] 'hippie-expand)

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

(use-package emacsql-sqlite-builtin)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-complete-everywhere)
  (org-roam-database-connector 'emacsql-sqlite))

;; Install lang support
(add-to-list 'safe-local-variable-values '(indent-tabs-mode . nil))

;; Fix tab isssue in tsx-ts-mode
(add-hook 'tsx-ts-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

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
(add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mdx\\'" . markdown-mode))

;; Load theme
(load-theme 'modus-vivendi t)

;; Custom background color for modus-vivendi
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#18181b")))))

;; User Interface
;; Get rid of scroll bar, menubar and toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Load custom files
(load-file(locate-user-emacs-file "custom/compile-ts.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(emacsql-sqlite-builtin vertico vc-use-package pet org-roam orderless markdown-mode marginalia magit gptel corfu-terminal consult)))
