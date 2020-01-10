;;; init.el --- emacs initialization -*- lexical-binding: t; -*-
;;; Commentary:
;; Beginner friendly emacs config
;;; Code:

;; Garbage collect every 100MB of allocated data rather than the low default
(setq-default gc-cons-threshold 104857600)

;; Answer yes or no with 'y' or 'n'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Load package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

;; Install package configuration tool
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure 't)


;; Set the path to the enviroment variable PATH always
(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

;; Keep =~/.emacs.d= clean. some libraries create variable files and/or
;; additional configuration files in the emacs user directory; no-littering
;; puts most of these files in =~/.emacs.d/var= and =~/.emacs.d/etc=
;; respectively.
(use-package no-littering :demand t)

(setq-default create-lockfiles nil)


;; Mode line is for showing all the active modes. Some of these are not useful
;; so let's hide them. This adds the =:diminish= key to =use-package= which will
;; hide the minor-mode associated with the package.
(use-package diminish :defer t)

;; Show total number of search matches and the current match index in the
;; modeline. See https://github.com/syohex/emacs-anzu
(use-package anzu
  :diminish anzu-mode
  :config (global-anzu-mode t))

;; Show buffer size
(size-indication-mode t)

;; Show cursor position in buffer
(line-number-mode t)
(column-number-mode t)

;; Disable startup clutter
(setq inhibit-startup-screen  t
      initial-scratch-message nil)

;; warn when opening files bigger than 100MB
(setq-default large-file-warning-threshold 104857600)

;; Disable the blinking cursor
(blink-cursor-mode -1)

;; Show keybindings when you begin typing a key chord
(use-package which-key
  :diminish which-key-mode
  :config (which-key-mode +1))

;; Set buffer names to a helpful unique name
(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style   'forward
        uniquify-separator           "/"
        ;; rename after killing uniquified
        uniquify-after-kill-buffer-p t
        ;; ignore system buffers
        uniquify-ignore-buffers-re   "^\\*"))

;; Auto revert files when they change on disk
(global-auto-revert-mode t)

;; Remember most recently run commands and text searches
(use-package smex
  :after ido
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config (smex-initialize))

;; Prefer to split vertically rather than horizontally.
;; Shamelessly stolen from stack overflow years ago.
(defun my-split-window (&optional window)
  "Split window more senibly.  WINDOW."
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window t)
             ;; Split window horizontally.
             (with-selected-window window
               (split-window-right)))
        (and (window-splittable-p window)
             ;; Split window vertically.
             (with-selected-window window
               (split-window-below)))
        (and (eq window (frame-root-window (window-frame window)))
             (not (window-minibuffer-p window))
             ;; If WINDOW is the only window on its frame and is not the
             ;; minibuffer window, try to split it horizontally disregarding
             ;; the value of `split-width-threshold'.
             (let ((split-width-threshold 0))
               (when (window-splittable-p window t)
                 (with-selected-window window
                   (split-window-right))))))))

(setq-default split-window-preferred-function #'my-split-window)

;; Show the cursor when moving after big movements in the window
(use-package beacon
  :diminish beacon-mode
  :config (beacon-mode +1))

;; Use ibuffer as the default buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)

(with-eval-after-load "ibuffer"
  (add-hook 'ibuffer-mode-hook 'ibuffer-auto-mode)
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-formats
  '((mark modified read-only " "
     (name 40 40 :left :elide) " " ;; 40 40 is the column width
     (size 9 -1 :right) " "
     (mode 8 8 :left :elide) " "
     filename-and-process)
    (mark " " (name 16 -1) " " filename))))

;; Better interactive mini-buffer menus
(use-package ido
  :config
  (progn
    (setq ido-enable-prefix                      nil
          ido-enable-flex-matching               t
          ido-create-new-buffer                  'always
          ido-use-filename-at-point              'guess
          ido-max-prospects                      10
          ido-default-file-method                'selected-window
          ido-auto-merge-work-directories-length -1)
    (ido-mode +1)))

(use-package ido-completing-read+
  :after ido
  :config (ido-ubiquitous-mode +1))

;; smarter fuzzy matching for ido
(use-package flx-ido
  :after ido
  :config (progn (flx-ido-mode +1)
                 ;; disable ido faces to see flx highlights
                 (setq ido-use-faces nil)))

;; Move between windows with M-<Arrow>
(global-set-key (kbd "M-<left>")  'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>")    'windmove-up)
(global-set-key (kbd "M-<down>")  'windmove-down)
(unless window-system
  (global-set-key (kbd "C-c <left>")  'windmove-left)
  (global-set-key (kbd "C-c <right>") 'windmove-right)
  (global-set-key (kbd "C-c <up>")    'windmove-up)
  (global-set-key (kbd "C-c <down>")  'windmove-down))

;; Make emacs aware of the project the file being edited belongs to
(use-package projectile
  :config (progn
            (global-set-key (kbd "C-c p") projectile-command-map)
            (projectile-mode t)))


(use-package ibuffer-projectile
  :after (:all projectile ibuffer-dynamic-groups)
  :config
  (add-hook 'ibuffer-hook #'ibuffer-projectile-set-filter-groups))

;; Make C-z, C-x, C-c, and C-v behave like a normal editor
(cua-mode t)

;; Use different colours for delimiters at different levels
(use-package rainbow-delimiters
  :hook ((prog-mode) . rainbow-delimiters-mode))

;; Always show line numbers
(global-linum-mode t)

;; Scrolling behaviour
(setq scroll-margin                   0
      scroll-conservatively           100000
      scroll-preserve-screen-position 1)

;; Use space instead of tabs
(setq-default indent-tabs-mode  nil
              tab-width         4
              tab-always-indent 'complete)

;; Cleanup whitespace on save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Add completion menu
(use-package company
  :diminish company-mode
  :config
  (progn
    (setq company-idle-delay 0.5
          company-show-numbers t
          company-tooltip-limit 10
          company-minimum-prefix-length 2
          company-tooltip-align-annotations t
          ;; invert the navigation direction if the the completion popup-isearch-match
          ;; is displayed on top (happens near the bottom of windows)
          company-tooltip-flip-when-above t)
    (global-company-mode 1)))

;; Highlight search results
(setq-default search-highlight t
              query-replace-highlight t)

;; Show matching paren under cursor (or mismatched parens)
(show-paren-mode t)

;; highlight color codes and names with the color
(use-package rainbow-mode
  :defer t
  :commands rainbow-mode
  :diminish rainbow-mode)

;; Highlight matching symbols beneath cursor
(use-package highlight-symbol
  :hook ((prog-mode) . highlight-symbol-mode)
  :config (set-face-attribute 'highlight-symbol-face nil
                    :background nil
                    :underline t))

;; Spellcheck
(use-package flyspell
  :commands flyspell-mode
  :config
  (setq-default flyspell-issue-welcome-flag nil
                flyspell-issue-message-flag nil
                ispell-program-name         "/usr/bin/aspell"
                ispell-list-command         "list"))

;; Code snippits
(use-package yasnippet
  :bind (:map yas-minor-mode-map
         ("C-`" . yas-expand)
         ("C-/" . yas-insert-snippet))
  :commands yas-minor-mode)

(use-package yasnippet-snippets
  :after yasnippets)

;; A more usable color scheme
(use-package monokai-theme
  :if window-system
  :config (load-theme 'monokai t))

;; Modeline enhancements
(use-package spaceline
  :if window-system
  :config
  (progn
    (require 'spaceline)
    (require 'spaceline-segments)

    (setq-default anzu-cons-mode-line-p           nil
                  powerline-default-separator     'contour
                  spaceline-minor-modes-separator " ")

    (defun my-spaceline-theme (&rest additional-segments)
      "Spaceline emacs theme with some tweaks"
      (spaceline-compile
       `((((((persp-name :fallback workspace-number) window-number)
            :separator "•")
           buffer-modified
           buffer-size)
          :face highlight-face
          :priority 100)
         (anzu :priority 95)
         auto-compile
         ((buffer-id remote-host)
          :priority 98)
         (major-mode :priority 79)
         (process :when active)
         ((flycheck-error flycheck-warning flycheck-info)
          :when active
          :priority 89)
         (minor-modes :when active
                      :priority 9)
         (mu4e-alert-segment :when active)
         (erc-track :when active)
         (version-control :when active
                          :priority 78)
         (org-pomodoro :when active)
         (org-clock :when active)
         nyan-cat)
       `(which-function
         (python-pyvenv :fallback python-pyenv)
         (purpose :priority 94)
         (battery :when active)
         (selection-info :priority 95)
         input-method
         ((point-position line-column)
          :separator " • "
          :priority 96)
         ((buffer-encoding-abbrev)
          :priority 9)
         (global :when active)
         ,@additional-segments
         (buffer-position :priority 99)
         (hud :priority 99)))
      (setq-default mode-line-format
                    '("%e" (:eval (spaceline-ml-main)))))

    (my-spaceline-theme)))

;; Use window dividers in xorg mode because it lets you drag to resize windows
(when window-system
  (setq-default window-divider-default-right-width 1)
  (window-divider-mode t))

;; Git modes
(use-package git)

(use-package magit
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package gitattributes-mode
  :defer t)

(use-package gitconfig-mode
  :defer t)

(use-package gitignore-mode
  :defer t)

;; Like postman but in emacs
(use-package restclient)

;; Org mode (like markdown but with more features)
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config (progn (add-hook 'org-mode-hook 'flyspell-mode)
                 (add-hook 'org-mode-hook 'yas-minor-mode)))

;; Emacs-lisp mode
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(with-eval-after-load "eldoc"
  (with-eval-after-load "diminish"
    (diminish 'eldoc-mode)))

(use-package auto-compile
  :config
  (progn
    (setq auto-compile-display-buffer    nil
          auto-compile-mode-line-counter t)
    (auto-compile-on-load-mode)
    (auto-compile-on-save-mode)))

;; Unix config files
(mapc (lambda (filename-regex)
        (add-to-list 'auto-mode-alist `(,filename-regex . conf-mode)))
      (list "\\.conf\\'"
            "\\.desktop\\'"
            "\\.service\\'"))

;; Clojure modes
(use-package clojure-mode
  :mode ("\\.edn\\'" "\\.clj\\'")
  :config (add-hook 'clojure-mode-hook 'subword-mode))

;; Clojure repl
(use-package cider
  :defer t
  :config (progn
            (setq nrepl-log-messages                   t
                  cider-inject-dependencies-at-jack-in t)
            (add-hook 'cider-mode-hook      'eldoc-mode)
            (add-hook 'cider-repl-mode-hook 'subword-mode)
            (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
            (define-key cider-mode-map (kbd "C-c f") 'cider-find-var)))

;; Cmake mode
(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :config (add-hook 'cmake-mode-hook 'yas-minor-mode))

;; Javascript
(use-package js2-mode
  :mode ("\\.js\\'" "\\.pac\\'")
  :interpreter "node")

;; Json
(use-package json-mode
  :mode "\\.json\\'")

;; Scheme
(use-package scheme
  :mode ("\\.scm\\'" . scheme-mode))

;; Scheme repl
(use-package geiser
  :defer t
  :config (setq geiser-mode-start-repl-p t))

;; Groovy (Jenkinsfiles)
(use-package groovy-mode
  :mode ("\\.groovy\\'" "JenkinsFile\\'"))

;; Dockerfiles
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; YAML
(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'"))

;; Markdown
(use-package markdown-mode
  :mode ("\\.md\\'" "\\.markdown\\'")
  :config (progn (add-hook 'markdown-mode-hook 'flyspell-mode)
                 (add-hook 'markdown-mode-hook 'yas-minor-mode)))

;; Lua
(use-package lua-mode
  :mode "\\.lua\\'")

;; Zsh
(let ((zsh-files '("zlogin" "zlogin" "zlogout" "zpreztorc"
                   "zprofile" "zshenv" "zshrc" ".zsh")))
  (add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))
  (mapc (lambda (file)
          (add-to-list 'auto-mode-alist
                       `(,(format "\\%s\\'" file) . sh-mode)))
        zsh-files)
  (add-hook 'sh-mode-hook
            (lambda ()
              (when
               (and buffer-file-name
                    (member (file-name-nondirectory buffer-file-name)
                            zsh-files))
               (sh-set-shell "zsh")))))

;; Terraform
(use-package terraform-mode
  :mode ("\\.tf\\'" "\\.tvars\\'"))

;; Additional Configuration goes here

;; Remove screen clutter
; (menu-bar-mode -1)
; (tool-bar-mode -1)
; (scroll-bar-mode -1)

;;
;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-align-annotations t)
 '(company-tooltip-flip-when-above t)
 '(custom-safe-themes
   (quote
    ("2925ed246fb757da0e8784ecf03b9523bccd8b7996464e587b081037e0e98001" default)))
 '(package-selected-packages
   (quote
    (gitattributes-mode terraform-mode lua-mode markdown-mode yaml-mode dockerfile-mode groovy-mode geiser json-mode js2-mode cmake-mode cider clojure-mode auto-compile restclient gitignore-mode gitconfig-mode gitattribute-mode magit git spaceline monokai-theme yasnippet-snippets yasnippet highlight-symbol rainbow-mode company rainbow-delimiters ibuffer-projectile projectile flx-ido ido-completing-read+ beacon smex which-key anzu diminish no-littering exec-path-from-shell use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:background "#272822" :foreground "dim gray" :inverse-video t :weight normal))))
 '(spaceline-flycheck-error ((t (:distant-foreground "#F70057" :foreground "#FA518D"))))
 '(spaceline-flycheck-info ((t (:distant-foreground "#40CAE4" :foreground "#92E7F7"))))
 '(spaceline-flycheck-warning ((t (:distant-foreground "#BEB244" :foreground "#FFF7A8"))))
 '(spaceline-highlight-face ((t (:background "#A6E22E" :foreground "#3E3D31" :inherit (quote mode-line)))))
 '(spaceline-modified ((t (:background "#92E7F7" :foreground "#3E3D31" :inherit (quote mode-line)))))
 '(spaceline-python-venv ((t (:distant-foreground "#FB35EA" :foreground "#FE8CF4"))))
 '(spaceline-read-only ((t (:background "#AE81FF" :foreground "#3E3D31" :inherit (quote mode-line)))))
 '(spaceline-unmodified ((t (:background "#a6e22e" :foreground "#3E3D31" :inherit (quote mode-line))))))
