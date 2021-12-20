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

;;; ----- Repositories -----
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
;;end repositories.

;;; ----- Custom Themes -----
(add-to-list 'custom-theme-load-path "~/.emacs-custom.d/themes/")

;;; -----General settings ------
;;Backups all in the same directory
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;;Disable menu bar, toolbar and scrollbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;Font
(set-face-attribute 'default nil
		    :font "FiraCode Nerd Font"
		    :height 100
		    )
;; Tip for fonts!!
;;Use `M-x describe-font’ to see the requested font and actual font being used.


;;Disable bells
(setq ring-bell-function 'ignore)

;;Show column number next to line number
(setq column-number-mode t)

;;Disable blinking cursor
(blink-cursor-mode 0)

;;Delete selection when typing a new chararacter
(delete-selection-mode 1)

;;Show trailing whitespace
(setq-default show-trailing-whitespace t)

;;Line numbers
(global-linum-mode)

;;Highlight current line
;;(global-hl-line-mode 1)

;;Tab triggers auto-completion
(setq tab-always-indent 'complete)

;;Highlight matching parentheses
(show-paren-mode)
(setq show-paren-delay 0)

;;Start in maximized mode
;;(toggle-frame-maximized)

;;Better defaults
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR." t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;end general settings

;;; ----- Packages -----
;;Async processing
(require 'async)
(autoload 'dired-async-mode "dired-async.el" nil t)
(dired-async-mode 1)
(async-bytecomp-package-mode 1)
(setq async-bytecomp-allowed-packages '(all))

;;Multiple major modes.
(require 'mmm-mode)

;;Flycheck syntax
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;;Eldoc settings
(setq eldoc-idle-delay 0.5)

;;Yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;Butler trim trailing whitespace
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)
(setq-default ws-butler-keep-whitespace-before-point nil)

;;Show visual line at max column length for file
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(setq fci-rule-width 3)
(add-hook 'prog-mode-hook 'fci-mode)
;;and add fix for company auto-completion
(defvar-local company-fci-mode-on-p nil)
(defun company-turn-off-fci (&rest ignore)
  (when (boundp 'fci-mode)
    (setq company-fci-mode-on-p fci-mode)
    (when fci-mode (fci-mode -1))))
(defun company-maybe-turn-on-fci (&rest ignore)
  (when company-fci-mode-on-p (fci-mode 1)))
(add-hook 'company-completion-started-hook 'company-turn-off-fci)
(add-hook 'company-completion-finished-hook 'company-maybe-turn-on-fci)
(add-hook 'company-completion-cancelled-hook 'company-maybe-turn-on-fci)
;;setup depending on programming language and dev environment
(defun fci-for-java (&rest ignore)
  (setq fci-rule-column 100))
(add-hook 'java-mode-hook 'fci-for-java)

;;Evil mode
(require 'evil)
;; (evil-mode t)
;; (evilnc-default-hotkeys)

;;which-key command hinting
(require 'which-key)
(which-key-mode)

;;Vertico command completion
(require 'vertico)
(vertico-mode)
;;...with Marginalia hint text
(require 'marginalia)
(marginalia-mode)

;;Company autocompletion
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;;do not force typing of matching completion
(setq-default company-require-match nil)
;;start completion after 1 character
(setq-default company-minimum-prefix-length 1)
;;no delay before showing completions
(setq-default company-idle-delay 0.15)
;;Company-quickhelp integration
(require 'company-quickhelp)
(company-quickhelp-mode 1)
;;delay on help popup
(setq-default company-quickhelp-delay 0.15)

;;Anaconda
(require 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
(eval-after-load "company"
  '(add-to-list 'company-backends 'company-anaconda))

;;Black code formatter
(add-hook 'anaconda-mode-hook 'python-black-on-save-mode)

;;pytest testing tool
(require 'pytest)

;;Python shell.
(setq python-shell-interpreter "python3")

;;Javascript2 mode.
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;;Meghanada Java development environment
(require 'meghanada)
(add-hook 'java-mode-hook
          (lambda ()
            ;; meghanada-mode on
            (meghanada-mode t)
            (flycheck-mode +1)
            (setq c-basic-offset 2)
            ;; use code format
            (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))
(cond
   ((eq system-type 'windows-nt)
    (setq meghanada-java-path (expand-file-name "bin/java.exe" (getenv "JAVA_HOME")))
    (setq meghanada-maven-path "mvn.cmd"))
   (t
    (setq meghanada-java-path "java")
    (setq meghanada-maven-path "mvn")))

;; Project management plugins
(require 'projectile)
(require 'neotree)

;; Emmet completion
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start emmet-mode on markup files
;;end packages


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(ansi-term-color-vector
   [unspecified "#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#a1efe4" "#fcfcfa"] t)
 '(awesome-tray-mode-line-active-color "#2fafff")
 '(awesome-tray-mode-line-inactive-color "#323232")
 '(beacon-color "#cc6666")
 '(buffer-expose-mode t)
 '(company-quickhelp-color-background "#e8e8e8")
 '(company-quickhelp-color-foreground "#444444")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes '(monokai-pro))
 '(custom-safe-themes
   '("d6da24347c813d1635a217d396cf1e3be26484fd4d05be153f3bd2b293d2a0b5" "0568a5426239e65aab5e7c48fa1abde81130a87ddf7f942613bf5e13bf79686b" "bedf9d7697f95381074fb2f02f417915b03a1c78ce207445a3a2178d44e36887" "1ac48c0de33d69da64e756db9c4c362429c09cfebbff5229431e6ee726aca3c0" "5b61f8b18975a8c280d495cc2dcd39784cbecf6f0736c623b8cd55beb2fb4629" "b38178d720f5349ec758490781471daa1048619e9ff04a9850234cc3dfcb6ad6" "a85e40c7d2df4a5e993742929dfd903899b66a667547f740872797198778d7b5" "3de3f36a398d2c8a4796360bfce1fa515292e9f76b655bb9a377289a6a80a132" "7bef2d39bac784626f1635bd83693fae091f04ccac6b362e0405abf16a32230c" "722e1cd0dad601ec6567c32520126e42a8031cd72e05d2221ff511b58545b108" "8c1dd3d6fdfb2bee6b8f05d13d167f200befe1712d0abfdc47bb6d3b706c3434" "aee999dbf73da1b3323e53938acf737074e2f8b09f363cd077de33bd89ea6c9c" "7d9edb10f60c3292e2bbb18c274ae1fceb713f64fc9ab9c775ca5d4760c601b4" "1f538e3de6aa8711e3ad8f297a57ee8210ade0f46f411c06343d126a4fea72c6" "f8484793c97806a5ae303807ee9ba291db59c52dd695f04777272facb5594475" "5cda52dd4e58e14dfc47470978adb7e457e66b389602e70a0485fc7e95755ca7" "60e09d2e58343186a59d9ed52a9b13d822a174b33f20bdc1d4abb86e6b17f45b" "aded4ec996e438a5e002439d58f09610b330bbc18f580c83ebaba026bbef6c82" "2d2e8a84d8865f3861fa895f22da5cfa7a3a2d2052adfbe259ea4f892d76c98b" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" "4eb6fa2ee436e943b168a0cd8eab11afc0752aebb5d974bba2b2ddc8910fca8f" "6bdcff29f32f85a2d99f48377d6bfa362768e86189656f63adbf715ac5c1340b" "78c4238956c3000f977300c8a079a3a8a8d4d9fee2e68bad91123b58a4aa8588" "83e0376b5df8d6a3fbdfffb9fb0e8cf41a11799d9471293a810deb7586c131e6" "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "fe15a6144a4f91dbd136c9d2ca74b1e13f502ac5c0b8a35d7daa2a97d2eabd29" "817e0f1f080b736d093e027415cd18957831f84a5c95b7963f95797bf5f84f2c" "adafd59891c8ea55a8c20afb4a5de5dfe4cf81e75bc8992c276992cb2ed98747" "ed49a2f0e2f329308a17a0d9ecdbe7dc05d440554f0e7bfd1497778f8ffde877" "888d95cf0e20998aef15a04969bedef99baa889053108d61e20f643e651d145a" "47f188b3ae4a3cdf29b54d3cf4b09ea1ec2cd15253879bfebbc568e86a25a81d" "c25d5ef5851d3036897e21f66d26bc1fa2a5ba89dbd15540604884a2fd163cc1" "3be1f5387122b935a26e02795196bc90860c57a62940f768f138b02383d9a257" "44961a9303c92926740fc4121829c32abca38ba3a91897a4eab2aa3b7634bed4" "7c0495f3973b9f79251205995ccccca41262b41a86553f81efe71c0dc3a50f43" "ef403aa0588ca64e05269a7a5df03a5259a00303ef6dfbd2519a9b81e4bce95c" "e6a9337674f6c967311b939bb4f81aefb65a96908c3749f4dd8d4500f6d79242" "91375c6dc506913ac7488f655b5afe934f343a0b223021c349105d37748c6696" "1d3863142a1325c1d038905c82b9aaf83f7594bb6158b52ad32ed23d3a97490a" "31e9b1ab4e6ccb742b3b5395287760a0adbfc8a7b86c2eda4555c8080a9338d9" "fb44ced1e15903449772b750c081e6b8f687732147aa43cfa2e7d9a38820744b" "46720e46428c490e7b2ddeafc2112c5a796c8cf4af71bd6b758d5c19316aff06" "8e51e44e5b079b2862335fcc5ff0f1e761dc595c7ccdb8398094fb8e088b2d50" "c2efd2e2e96b052dd91940b100d86885337a37be1245167642451cf6da5b924a" "65f35d1e0d0858947f854dc898bfd830e832189d5555e875705a939836b53054" "819d24b9aba8fcb446aecfb59f87d1817a6d3eb07de7fdec67743ef32194438b" "ea6fd1ecc660fb434e19ed6b6d193bd25670bfcb6a955dfa21662da90184ba0c" "998975856274957564b0ab8f4219300bca12a0f553d41c1438bbca065f298a29" "c9f102cf31165896631747fd20a0ca0b9c64ecae019ce5c2786713a5b7d6315e" "6145e62774a589c074a31a05dfa5efdf8789cf869104e905956f0cbd7eda9d0e" "f6f5d5adce1f9a764855c9730e4c3ef3f90357313c1cae29e7c191ba1026bc15" "64e3f7a494ad5491dea52e49253ee807be7799a4758822725fe29682abfe0cf7" "f66abed5139c808607639e5a5a3b5b50b9db91febeae06f11484a15a92bde442" "cbd8e65d2452dfaed789f79c92d230aa8bdf413601b261dbb1291fb88605110c" "4bf5c18667c48f2979ead0f0bdaaa12c2b52014a6abaa38558a207a65caeb8ad" "df21cdadd3f0648e3106338649d9fea510121807c907e2fd15565dde6409d6e9" "ecd8267ae99aa12d766f37bea093a6a3e3138494416956dcad29182e0fad69f8" "87d46d0ad89557c616d04bef34afd191234992c4eb955ff3c60c6aa3afc2e5cc" "fede08d0f23fc0612a8354e0cf800c9ecae47ec8f32c5f29da841fe090dfc450" "99c86852decaeb0c6f51ce8bd46e4906a4f28ab4c5b201bdc3fdf85b24f88518" "0c3b1358ea01895e56d1c0193f72559449462e5952bded28c81a8e09b53f103f" "53d05b14dd036942fc8e14ef1375b303e4586a51a28d76c26c608ad8188235bf" "cfb7f51dcfd7a42080fce44babd015f6148524427dea0d27935876880105a391" "1bb8f76bcd04a2b25a663a3da69235fbdbe9db1d5fe7efc6e8fcfc5e1030c9c3" "ee10794cb2deb2e0dc094145980d518661cc5092769192153ae8bdbd24fba3fc" "b6493078dc17528c57a3eb6b334e496217d026d856261b349603c9845f3cf2d8" "d2bd16a8bcf295dce0b70e1d2b5c17bb34cb28224a86ee770d56e6c22a565013" "8be07a2c1b3a7300860c7a65c0ad148be6d127671be04d3d2120f1ac541ac103" "bc4c89a7b91cfbd3e28b2a8e9e6750079a985237b960384f158515d32c7f0490" "80930c775cef2a97f2305bae6737a1c736079fdcc62a6fdf7b55de669fbbcd13" "350dc341799fbbb81e59d1e6fff2b2c8772d7000e352a5c070aa4317127eee94" "196df8815910c1a3422b5f7c1f45a72edfa851f6a1d672b7b727d9551bb7c7ba" "250268d5c0b4877cc2b7c439687f8145a2c85a48981f7070a72c7f47a2d2dc13" "d96587ec2c7bf278269b8ec2b800c7d9af9e22d816827639b332b0e613314dfd" "5b8eccff13d79fc9b26c544ee20e1b0c499587d6c4bfc38cabe34beaf2c2fc77" "3f67aee8f8d8eedad7f547a346803be4cc47c420602e19d88bdcccc66dba033b" "dad1453029a183e5837ebfd7de65f74df7e06554e39468c758c8197bfa749fec" "8543b328ed10bc7c16a8a35c523699befac0de00753824d7e90148bca583f986" "ad16a1bf1fd86bfbedae4b32c269b19f8d20d416bd52a87cd50e355bf13c2f23" "d83e34e28680f2ed99fe50fea79f441ca3fddd90167a72b796455e791c90dc49" "100eeb65d336e3d8f419c0f09170f9fd30f688849c5e60a801a1e6addd8216cb" "fee4e306d9070a55dce4d8e9d92d28bd9efe92625d2ba9d4d654fc9cd8113b7f" "6daa09c8c2c68de3ff1b83694115231faa7e650fdbb668bc76275f0f2ce2a437" "4a91a64af7ff1182ed04f7453bb5a4b0c3d82148d27db699df89a5f1d449e2a4" "8cf1002c7f805360115700144c0031b9cfa4d03edc6a0f38718cef7b7cabe382" "12670281275ea7c1b42d0a548a584e23b9c4e1d2dabb747fd5e2d692bcd0d39b" "36746ad57649893434c443567cb3831828df33232a7790d232df6f5908263692" "aea30125ef2e48831f46695418677b9d676c3babf43959c8e978c0ad672a7329" "1263771faf6967879c3ab8b577c6c31020222ac6d3bac31f331a74275385a452" "93268bf5365f22c685550a3cbb8c687a1211e827edc76ce7be3c4bd764054bad" "73ad471d5ae9355a7fa28675014ae45a0589c14492f52c32a4e9b393fcc333fd" "9be1d34d961a40d94ef94d0d08a364c3d27201f3c98c9d38e36f10588469ea57" "b8929cff63ffc759e436b0f0575d15a8ad7658932f4b2c99415f3dde09b32e97" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" "16dd114a84d0aeccc5ad6fd64752a11ea2e841e3853234f19dc02a7b91f5d661" "c968804189e0fc963c641f5c9ad64bca431d41af2fb7e1d01a2a6666376f819c" "36282815a2eaab9ba67d7653cf23b1a4e230e4907c7f110eebf3cdf1445d8370" "146061a7ceea4ccc75d975a3bb41432382f656c50b9989c7dc1a7bb6952f6eb4" "85d609b07346d3220e7da1e0b87f66d11b2eeddad945cac775e80d2c1adb0066" "9c4acf7b5801f25501f0db26ac3eee3dc263ed51afd01f9dcfda706a15234733" "f984e2f9765a69f7394527b44eaa28052ff3664a505f9ec9c60c088ca4e9fc0b" "dd4628d6c2d1f84ad7908c859797b24cc6239dfe7d71b3363ccdd2b88963f336" "169070e358960ebebe946874fa55c109e37d57868500bc288b3946892f023e23" "37046960cf667c5ab3b76235d35a5db4763c531e706502a9067fa78db5a775c0" "cc71cf67745d023dd2e81f69172888e5e9298a80a2684cbf6d340973dd0e9b75" "3380a2766cf0590d50d6366c5a91e976bdc3c413df963a0ab9952314b4577299" "cea3ec09c821b7eaf235882e6555c3ffa2fd23de92459751e18f26ad035d2142" "446cc97923e30dec43f10573ac085e384975d8a0c55159464ea6ef001f4a16ba" "d9dab332207600e49400d798ed05f38372ec32132b3f7d2ba697e59088021555" "fec45178b55ad0258c5f68f61c9c8fd1a47d73b08fb7a51c15558d42c376083d" "6271fc9740379f8e2722f1510d481c1df1fcc43e48fa6641a5c19e954c21cc8f" "50d07ab55e2b5322b2a8b13bc15ddf76d7f5985268833762c500a90e2a09e7aa" "4feee83c4fbbe8b827650d0f9af4ba7da903a5d117d849a3ccee88262805f40d" "264b639ee1d01cd81f6ab49a63b6354d902c7f7ed17ecf6e8c2bd5eb6d8ca09c" "e1498b2416922aa561076edc5c9b0ad7b34d8ff849f335c13364c8f4276904f0" "808b47c5c5583b5e439d8532da736b5e6b0552f6e89f8dafaab5631aace601dd" "1025e775a6d93981454680ddef169b6c51cc14cea8cb02d1872f9d3ce7a1da66" "5a39d2a29906ab273f7900a2ae843e9aa29ed5d205873e1199af4c9ec921aaab" "840db7f67ce92c39deb38f38fbc5a990b8f89b0f47b77b96d98e4bf400ee590a" "a62f0662e6aa7b05d0b4493a8e245ab31492765561b08192df61c9d1c7e1ddee" "04790c9929eacf32d508b84d34e80ad2ee233f13f17767190531b8b350b9ef22" "428bdd4b98d4d58cd094e7e074c4a82151ad4a77b9c9e30d75c56dc5a07f26c5" "f5f3a6fb685fe5e1587bafd07db3bf25a0655f3ddc579ed9d331b6b19827ea46" "b0c5c6cc59d530d3f6fbcfa67801993669ce062dda1435014f74cafac7d86246" "542e6fee85eea8e47243a5647358c344111aa9c04510394720a3108803c8ddd1" "304c39b190267e9b863c0cf9c989da76dcfbb0649cbcb89592e7c5c08348fce9" "ffac21ab88a0f4603969a24b96993bd73a13fe0989db7ed76d94c305891fad64" "ec3e6185729e1a22d4af9163a689643b168e1597f114e1cec31bdb1ab05aa539" "45a8b89e995faa5c69aa79920acff5d7cb14978fbf140cdd53621b09d782edcf" "69e7e7069edb56f9ed08c28ccf0db7af8f30134cab6415d5cf38ec5967348a3c" "41eb3fe4c6b80c7ad156a8c52e9dd6093e8856c7bbf2b92cc3a4108ceb385087" "732ccca2e9170bcfd4ee5070159923f0c811e52b019106b1fc5eaa043dff4030" "fc7fd2530b82a722ceb5b211f9e732d15ad41d5306c011253a0ba43aaf93dccc" "0961d780bd14561c505986166d167606239af3e2c3117265c9377e9b8204bf96" "3e34e9bf818cf6301fcabae2005bba8e61b1caba97d95509c8da78cff5f2ec8e" "b67b2279fa90e4098aa126d8356931c7a76921001ddff0a8d4a0541080dee5f6" "cabc32838ccceea97404f6fcb7ce791c6e38491fd19baa0fcfb336dcc5f6e23c" "a61109d38200252de49997a49d84045c726fa8d0f4dd637fce0b8affaa5c8620" "1d079355c721b517fdc9891f0fda927fe3f87288f2e6cc3b8566655a64ca5453" "c614d2423075491e6b7f38a4b7ea1c68f31764b9b815e35c9741e9490119efc0" "760ce657e710a77bcf6df51d97e51aae2ee7db1fba21bbad07aab0fa0f42f834" "34ed3e2fa4a1cb2ce7400c7f1a6c8f12931d8021435bad841fdc1192bd1cc7da" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "660376e0336bb04fae2dcf73ab6a1fe946ccea82b25f6800d51977e3a16de1b9" "3a959a1c1765710e5478882053e56650852821e934c3d98f54860dfb91a52626" "c2e1201bb538b68c0c1fdcf31771de3360263bd0e497d9ca8b7a32d5019f2fae" "00c5138bb71c95ca37a0fc845656498a8b4ff271ba4e0e0845732d188359d55a" "e8825f26af32403c5ad8bc983f8610a4a4786eb55e3a363fa9acb48e0677fe7e" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" "9375315e4786e5cc84b739537102802c18650f3168cf7c29f7fbb00a54f9b8e0" "8feca8afd3492985094597385f6a36d1f62298d289827aaa0d8a62fe6889b33c" "1924dfdcebb895e2ad44ce4835c070d8c8bfc7eba95727f0ff2efee5e4bc25ab" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "c665e247614a990c845ba7e450c6f8141a9fc1cd3e7e7e0c2ed94530f2de65f8" "bf10bd6d21928bf87bc3032b498c62cb9d48c54c06d217c8b00bef8090e539f7" "549ccbd11c125a4e671a1e8d3609063a91228e918ffb269e57bd2cd2c0a6f1c6" "5185a285365a768a30ac274bdbc4437e7fd2fbe3107a1b0f2b60e900181905e0" "d9646b131c4aa37f01f909fbdd5a9099389518eb68f25277ed19ba99adeb7279" "27b97024320d223cbe0eb73104f2be8fcc55bd2c299723fc61d20057f313b51c" "8adeb0bf3e77356c0aa34dd447f8e52ba56f8f9d4ce58d7c020f00e4bfff32f6" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "8e797edd9fa9afec181efbfeeebf96aeafbd11b69c4c85fa229bb5b9f7f7e66c" "2b9dc43b786e36f68a9fd4b36dd050509a0e32fe3b0a803310661edb7402b8b6" "b583823b9ee1573074e7cbfd63623fe844030d911e9279a7c8a5d16de7df0ed0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "8f97d5ec8a774485296e366fdde6ff5589cf9e319a584b845b6f7fa788c9fa9a" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7" "7922b14d8971cce37ddb5e487dbc18da5444c47f766178e5a4e72f90437c0711" "89885317e7136d4e86fb842605d47d8329320f0326b62efa236e63ed4be23c58" "9abe2b502db3ed511fea7ab84b62096ba15a3a71cdb106fd989afa179ff8ab8d" "24168c7e083ca0bbc87c68d3139ef39f072488703dcdd82343b8cab71c0f62a7" "fb83a50c80de36f23aea5919e50e1bccd565ca5bb646af95729dc8c5f926cbf3" "e3a1b1fb50e3908e80514de38acbac74be2eb2777fc896e44b54ce44308e5330" "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99" "b02eae4d22362a941751f690032ea30c7c78d8ca8a1212fdae9eecad28a3587f" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" "5e3fc08bcadce4c6785fc49be686a4a82a356db569f55d411258984e952f194a" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "ab04c00a7e48ad784b52f34aa6bfa1e80d0c3fcacc50e1189af3651013eb0d58" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "7356632cebc6a11a87bc5fcffaa49bae528026a78637acd03cae57c091afd9b9" "43f03c7bf52ec64cdf9f2c5956852be18c69b41c38ab5525d0bedfbd73619b6a" "332a945a80a202248b21963da38e842aa35b09d1b43c26144bd517943855fe8a" "c3c39b9bf9824d4fa591fbf785a2cb507607f2f36fef05363d6f2dca5c6db82b" "2b502f6e3bf0cba42fe7bf83a000f2d358a7020a7780a8682fcfed0c9dbffb5f" "076ee9f2c64746aac7994b697eb7dbde23ac22988d41ef31b714fc6478fee224" "b5e75f219d41e6e3516560ac493d808b621a99847d6128ce8e6c74b1495ce875" "5111a41453244802afd93eed1a434e612a8afbdf19c52384dffab129258bab6e" default))
 '(diary-entry-marker 'font-lock-variable-name-face)
 '(emms-mode-line-icon-color "#1fb3b3")
 '(emms-mode-line-icon-image-cache
   '(image :type xpm :ascent center :data "/* XPM */
static char *note[] = {
/* width height num_colors chars_per_pixel */
\"    10   11        2            1\",
/* colors */
\". c #358d8d\",
\"# c None s None\",
/* pixels */
\"###...####\",
\"###.#...##\",
\"###.###...\",
\"###.#####.\",
\"###.#####.\",
\"#...#####.\",
\"....#####.\",
\"#..######.\",
\"#######...\",
\"######....\",
\"#######..#\" };"))
 '(exwm-floating-border-color "#646464")
 '(fci-rule-color "#222222")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(flymake-error-bitmap '(flymake-double-exclamation-mark modus-themes-fringe-red))
 '(flymake-note-bitmap '(exclamation-mark modus-themes-fringe-cyan))
 '(flymake-warning-bitmap '(exclamation-mark modus-themes-fringe-yellow))
 '(frame-background-mode 'dark)
 '(gnus-logo-colors '("#259ea2" "#adadad") t)
 '(gnus-mode-line-image-cache
   '(image :type xpm :ascent center :data "/* XPM */
static char *gnus-pointer[] = {
/* width height num_colors chars_per_pixel */
\"    18    13        2            1\",
/* colors */
\". c #358d8d\",
\"# c None s None\",
/* pixels */
\"##################\",
\"######..##..######\",
\"#####........#####\",
\"#.##.##..##...####\",
\"#...####.###...##.\",
\"#..###.######.....\",
\"#####.########...#\",
\"###########.######\",
\"####.###.#..######\",
\"######..###.######\",
\"###....####.######\",
\"###..######.######\",
\"###########.######\" };") t)
 '(highlight-changes-colors '("#FD5FF0" "#AE81FF"))
 '(highlight-parentheses-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(highlight-symbol-colors
   '("#3b6b40f432d7" "#07b9463d4d37" "#47a3341f358a" "#1d873c4056d5" "#2d87441c3362" "#43b7362e3199" "#061e418059d7"))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors '(("#2f4a00" . 0) ("#00415e" . 20)))
 '(hl-bg-colors
   '("#866300" "#992700" "#a7020a" "#a00559" "#243e9b" "#0061a8" "#007d76" "#5b7300"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-paren-background-colors '("#e8fce8" "#e1faff" "#f8e8e8"))
 '(hl-paren-colors '("#005500" "#1054af" "#880000"))
 '(hl-sexp-background-color "#efebe9")
 '(hl-todo-keyword-faces
   '(("HOLD" . "#c0c530")
     ("TODO" . "#feacd0")
     ("NEXT" . "#b6a0ff")
     ("THEM" . "#f78fe7")
     ("PROG" . "#00d3d0")
     ("OKAY" . "#4ae2f0")
     ("DONT" . "#70b900")
     ("FAIL" . "#ff8059")
     ("BUG" . "#ff8059")
     ("DONE" . "#44bc44")
     ("NOTE" . "#d3b55f")
     ("KLUDGE" . "#d0bc00")
     ("HACK" . "#d0bc00")
     ("TEMP" . "#ffcccc")
     ("FIXME" . "#ff9077")
     ("XXX+" . "#ef8b50")
     ("REVIEW" . "#6ae4b9")
     ("DEPRECATED" . "#bfd9ff")))
 '(ibuffer-deletion-face 'modus-themes-mark-del)
 '(ibuffer-filter-group-name-face 'modus-themes-pseudo-header)
 '(ibuffer-marked-face 'modus-themes-mark-sel)
 '(ibuffer-title-face 'default)
 '(linum-format " %7i ")
 '(lsp-ui-doc-border "#93a1a1")
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4"))
 '(org-src-block-faces 'nil)
 '(package-selected-packages
   '(php-mode emmet-mode neotree pyvenv projectile python-black yasnippet-snippets racket-mode modus-themes async firecode-theme doneburn-theme base16-theme badger-theme alect-themes acme-theme color-theme-sanityinc-tomorrow github-modern-theme gruvbox-theme fill-column-indicator sublime-themes tango-plus-theme devdocs pytest poetry anaconda-mode python pdb-capf jetbrains-darcula-theme jedi marginalia vertico c-eldoc cl-print monokai-pro-theme monokai-theme material-theme dracula-theme zenburn-theme magit web-mode ws-butler ztree xclip which-key realgud-node-inspect realgud-jdb realgud-ipdb realgud mmm-mode memory-usage json-mode js2-mode frame-tabs flylisp el-search eldoc-eval eldoc evil-nerd-commenter evil-org epc evil org))
 '(pdf-view-midnight-colors '("#ffffff" . "#100f10"))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(red "#ffffff")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(sml/active-background-color "#e1faff")
 '(sml/active-foreground-color "#444444")
 '(sml/inactive-background-color "#1054af")
 '(sml/inactive-foreground-color "#444444")
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#ff8059")
     (40 . "#feacd0")
     (60 . "#f78fe7")
     (80 . "#ef8b50")
     (100 . "#d0bc00")
     (120 . "#c0c530")
     (140 . "#f8dec0")
     (160 . "#bfebe0")
     (180 . "#44bc44")
     (200 . "#70b900")
     (220 . "#6ae4b9")
     (240 . "#4ae2f0")
     (260 . "#00d3d0")
     (280 . "#c6eaff")
     (300 . "#2fafff")
     (320 . "#79a8ff")
     (340 . "#00bcff")
     (360 . "#b6a0ff")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
 '(when
      (or
       (not
	(boundp 'ansi-term-color-vector))
       (not
	(facep
	 (aref ansi-term-color-vector 0)))))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["black" "#ff8059" "#44bc44" "#d0bc00" "#2fafff" "#feacd0" "#00d3d0" "gray65"])
 '(xterm-color-names-bright
   ["gray35" "#ef8b50" "#70b900" "#c0c530" "#79a8ff" "#f78fe7" "#4ae2f0" "white"]))


;;; ----- My custom-set variables
;;(setq company-quickhelp-color-background "#4F4F4F") backup
;;(setq company-quickhelp-color-foreground "#DCDCCC") backup
;;(setq pos-tip-background-color "#FFFACE") backup
;;(setq pos-tip-foreground-color "#272822") backup

;;; ----- System-made custom variables. DON'T TOUCH THIS

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))

;;; ----- My custom keybindings
;;put stuff here

(provide 'init)
;;; init.el ends here
