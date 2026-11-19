;; Suppress warning about package cl being deprecated
(setq byte-compile-warnings '(cl-functions))

;; package repos
(package-initialize)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(dolist (package '(use-package))
   (unless (package-installed-p package)
       (package-install package)))

;; Ensure packages are installed.
(use-package package :ensure t)
(use-package ido :ensure t)
(use-package flycheck :ensure t)
(use-package neotree :ensure t)
(use-package ace-window :ensure t)
(use-package web-mode :ensure t)
(use-package emmet-mode :ensure t)
(use-package pyvenv :ensure t)

;; special file backup dir
(setq backup-directory-alist `(("." . "~/.saves-emacs")))
;; Remove auto-saves when doing a formal save in the file in question
(setq delete-auto-save-files t)

;; No menu bar
(menu-bar-mode -1)
;; No scroll bar
(scroll-bar-mode -1)
;; No toolbar
(tool-bar-mode -1)
;; No splash screen
(setq inhibit-splash-screen t)
;; No bell
(setq ring-bell-function 'ignore)
;; Use spaces, not tabs, for indentation
(setq-default indent-tabs-mode nil)
;; Overwrite highlighted text
(delete-selection-mode 1)
;; Set indentation width. Don't use this, use mode hooks with c-set-style
;; if possible?? (revisit this later)
(setq tab-width 4
      c-basic-offset tab-width
      cperl-indent-level tab-width)

;; Customize various programming languages indentation styles.
(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "gnu")
                        ;; Set C indentation style to K&R
                        (c-mode . "k&r")
                        ))

;; Set tabwidth to 4 and set tabs as spaces for Golang.
(defun my-go-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Disable accelerative mouse scrolling speed
(setq mouse-wheel-progressive-speed nil)
;; Set scroll wheel scroll increment
(setq mouse-wheel-scroll-amount '(2 ((shift) . 2) ((control) . nil)))
;; Scroll window under mouse
(setq mouse-wheel-follow-mouse 't)

;; custom themes directory
(add-to-list 'custom-theme-load-path "~/.emacs-default.d/themes")

;; Leuven theme
;;(load-theme 'leuven t)
;; Zenburn theme
(load-theme 'zenburn t)
;; Gruvbox Medium Dark Theme
;;(load-theme 'gruvbox-dark-medium t)

;; Set custom font
(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono 10" ))
;; (set-face-attribute 'default t :font "DejaVu Sans Mono 12" )
;; Another way to set the font size. using :height sets the font to 1/10th of the given value. Here,
;; this would by in font size 10. Note that this may conflict with the settings above.
;; (set-face-attribute 'default nil :height 100)


;; Column numbers
(setq column-number-mode t)

;; Highlight matching brackets/parentheses
(add-hook 'prog-mode-hook #'show-paren-mode)

;; Highlight current line mode in programming modes
(add-hook 'prog-mode-hook #'hl-line-mode)

;; Fix hl-line-mode overriding hi-lock-mode highlighting
;; TODO

;; Highlight TODOs
;;(require 'hl-todo)

;; Replace current buffer instead of opening new ones in Dired-mode
(eval-after-load "dired"
  '(progn
     (defadvice dired-advertised-find-file (around dired-subst-directory activate)
       "Replace current buffer if file is a directory."
       (interactive)
       (let* ((orig (current-buffer))
              ;; (filename (dired-get-filename))
              (filename (dired-get-filename t t))
              (bye-p (file-directory-p filename)))
         ad-do-it
         (when (and bye-p (not (string-match "[/\\\\]\\.$" filename)))
           (kill-buffer orig))))))

;; Setup a nice programming environment
;;(defun my-do-stuff ()
;;  (toggle-frame-fullscreen)
  ;;(split-window-vertically)
;;  (neotree)
;;  (other-window 1)
  ;;(other-window 3)
  ;;(eshell)
  ;;(other-window 2)
  ;;(window-resize nil +17)
  ;;(other-window 2)
;;  )
;;(add-hook 'after-init-hook #'my-do-stuff)

;; ido-mode
(require 'ido)
(ido-mode t)

;; Single buffer for dired navigation
(add-hook 'dired-mode-hook
  (lambda ()
   (local-set-key [?\r] 'dired-find-alternate-file)))

;; flycheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; neotree
(require 'neotree)

;; ace-window
(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; emmet-mode
(require 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'nxml-mode-hook 'emmet-mode)

;; python
;;(require 'python)
(require 'pyvenv)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("18ea0bce821489c49001dd4633ff41b1e6119adee845001236fe7e3279fb4c93"
     default))
 '(package-selected-packages
   '(ace-window adoc-mode docker-compose-mode dockerfile-mode
                dracula-theme emmet-mode flycheck go-mode
                gruvbox-theme hl-todo markdown-mode neotree php-mode
                python use-package web-mode web-mode-edit-element
                yaml-mode))
 '(warning-suppress-log-types '((comp) (comp) (comp) (comp) (comp) (comp) (comp) (comp)))
 '(warning-suppress-types '((comp) (comp) (comp) (comp) (comp) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
