;; Suppress warning about package cl being deprecated
(setq byte-compile-warnings '(cl-functions))

;; package repos
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)


;; special file backup dir
(setq backup-directory-alist `(("." . "~/.saves-emacs")))
;; Remove auto-saves when doing a formal save in the file in question
(setq delete-auto-save-files t)

;; No menu bar
(menu-bar-mode -1)
;; No scroll bar
;;(scroll-bar-mode -1)
;; No toolbar
(tool-bar-mode -1)

;; custom themes directory
(add-to-list 'custom-theme-load-path "~/.emacs-default.d/themes")

;; Zenburn theme
(load-theme 'zenburn t)

;; Column numbers
(setq column-number-mode t)

;; Highlight matching brackets/parentheses
(add-hook 'prog-mode-hook #'show-paren-mode)

;; Highlight current line mode in programming modes
(add-hook 'prog-mode-hook #'hl-line-mode)

;; ido-mode
(require 'ido)
(ido-mode t)

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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("18ea0bce821489c49001dd4633ff41b1e6119adee845001236fe7e3279fb4c93" default))
 '(package-selected-packages
   '(yaml-mode emmet-mode markdown-mode flycheck neotree ace-window web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
