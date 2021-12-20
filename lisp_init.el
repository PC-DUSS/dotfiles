;;; Garbage collector startup optimization and timer
;;The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;;Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
;;Garbage collector startup optim ends here

;; Welcome screen
(display-splash-screen)

;;; ----- Repositories -----
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
;;end repositories.

;;; ----- Custom Themes -----
(add-to-list 'custom-theme-load-path "~/.emacs-lisp.d/themes/")

;;; -----General settings ------
;;Backups all in the same directory
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;;Disable menu bar, toolbar and scrollbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;Font settings
;;The height value is in 1/10pt, so 100 will give you 10pt, etc.
(set-face-attribute 'default nil
		    :height 110
		    :font "DejaVu Sans Mono"
		    )
;; Tip for fonts!!
;;Use `M-x describe-font’ to see the requested font and actual font being used.

;;Disable bells
(setq ring-bell-function 'ignore)

;;Show column number next to line number
(setq column-number-mode t)

;;Delete selection when typing a new chararacter
(delete-selection-mode 1)

;;Show trailing whitespace
(setq-default show-trailing-whitespace t)

;;Tab triggers auto-completion
;;(setq tab-always-indent 'complete)

;;Highlight matching parentheses
(show-paren-mode)
(setq show-paren-delay 0)

;; Ido mode on permanently
;;(setq ido-enable-flex-matching t) regex style completion
(setq ido-everywhere t)
(ido-mode 1)

;; Fido mode enabled: minibuffer completion
(fido-mode t)

;; ElDoc mode for major modes
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)
(add-hook 'python-mode-hook 'eldoc-mode)
;; end general settings

;;;;;;;;;;;;;;;;;;;;;;;
;; Packages

;;Evil mode
;;(require 'evil)
;; (evil-mode t)
;; (evilnc-default-hotkeys)




(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(racket-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
