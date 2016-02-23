;;; init --- init
;;; Commentary:
;;; Code:


(package-initialize)
(require 'cl)
;;(setq debug-on-error t)


(defun set-PATH ()
  "Set system shell path."
  (let ((path-from-shell
	 (shell-command-to-string "TERM=vt100 $SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(setq my:el-get-packages
      '(el-get
	evil
	session
	nyan-mode
	elm-mode
	company
	mode-icons
	ace-jump-mode
;;	emacs-w3m
	neotree
	minimap
	gtags
	tabbar
	js2-mode
	jsx-mode
	esup
	jedi
	company-jedi
	jedi-core
	coffee-mode
	multi-term
	tabbar-ruler
	projectile
	find-file-in-repository
	ack
	linum-relative
	monokai-theme
	dash
	powerline
	git-emacs
	popup
	markdown-mode
	yasnippet
	haskell-mode
	smooth-scrolling
	flycheck
	diminish
	elpy
	whitespace-cleanup-mode
	auto-highlight-symbol
	scss-mode
	undo-tree))


;; install el-get
(defun init-el-get (lst)
  "`LST' : package list."
  (setq el-get-git-shallow-clone t)
  (setq el-get-user-package-directory "~/.emacs.d")
  (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
  (add-to-list 'load-path "~/.emacs.d/dev")
  (unless (require 'el-get nil 'noerror)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
      (let (el-get-master-branch
	    ;; do not build recipes from emacswiki due to poor quality and
	    ;; documentation
	    el-get-install-skip-emacswiki-recipes)
	(goto-char (point-max))
	(eval-print-last-sexp)))
    ;; build melpa packages for el-get
    (el-get-install 'package)
    (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			     ("melpa" . "http://melpa.org/packages/")))
    (el-get-elpa-build-local-recipes))
  ;; enable git shallow clone to save time and bandwidth
  (when (el-get-executable-find "cvs")
    (add-to-list 'lst 'emacs-goodies-el)) ; the debian addons for emacs

  (when (el-get-executable-find "svn")
    (loop for p in '(psvn    ; M-x svn-status
		     yasnippet; powerful snippet mode
		     )
	  do (add-to-list 'lst p))))


(defun toggle-fullscreen ()
  "Toggle full screen."
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

(defun init-key-binding ()
  "Set global key bindings."

  (require 'neotree)
  (require 'minimap)
  (setq neo-window-width 28)
  (when window-system
    (setq mac-option-modifier 'alt)
    (setq mac-command-modifier 'meta))
    ;;;###autoload

  (defun minimap-toggle ()
    "Toggle minimap for current buffer."
    (interactive)
    (if (not (boundp 'minimap-bufname))
	(setf minimap-bufname nil))

    (if (null minimap-bufname)
	(progn (minimap-create)
	       (setf minimap-bufname t))
      (progn (minimap-kill)
	     (setf minimap-bufname nil))))
  ;;  (define-key ac-completing-map "\C-n" 'ac-next)
  ;;  (define-key ac-completing-map "\C-p" 'ac-previous)
  ;;  (global-set-key "\t" 'company-complete-common)
  (global-set-key (kbd "M-p") 'tabbar-ruler-forward)
  (global-set-key (kbd "M-n") 'tabbar-ruler-backward)
  (global-set-key [C-tab] 'other-window)
  (global-set-key (kbd "C-o") 'other-frame)
  (global-set-key (kbd "C-/") 'undo)
  (global-set-key (kbd "C-?") 'redo)
  (global-set-key (kbd "C-c d") 'git-diff-all-head)
  (global-set-key (kbd "C-c p") 'nyan-pomodoro)
  (global-set-key (kbd "M-RET") 'toggle-fullscreen)
  (global-set-key (kbd "M-m") 'idomenu)
  (global-set-key (kbd "C-x f") 'find-file-in-repository)
  (global-set-key "\C-x\C-b" 'ibuffer)
  (global-set-key (kbd "M-m") 'minimap-toggle)
  (global-set-key (kbd "M-s") 'neotree-toggle)
  (global-set-key (kbd "C-c SPC") 'ace-jump-mode)
  ;;  (setq projectile-switch-project-action 'neotree-projectile-action)
  (global-set-key [(meta shift p)] 'tabbar-backward)
  (global-set-key [(meta shift n)] 'tabbar-forward)
  (global-set-key (kbd"C-x C-Q") 'loop-alpha)
  (global-set-key (kbd "C-x 4") 'balance-windows))

(defun config () "\
config detail settings"
       (setq tramp-default-method "sshx")
       (cua-selection-mode 1)
       (global-undo-tree-mode)
       (setq password-cache-expiry nil)
       (setq scroll-margin 3
	     scroll-step 1
	     scroll-conservatively 10000)
       (setq mouse-wheel-progressive-speed nil)
       (setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
       (setq tab-width 4)
       (setq current-language-environment "UTF-8")
       (prefer-coding-system 'utf-8)
       (set-keyboard-coding-system 'utf-8)
       (set-clipboard-coding-system 'utf-8)
       (set-terminal-coding-system 'utf-8)
       (set-buffer-file-coding-system 'utf-8)
       (set-default-coding-systems 'utf-8)
       (set-selection-coding-system 'utf-8)
       (modify-coding-system-alist 'process "*" 'utf-8)
       (setq default-process-coding-system '(utf-8 . utf-8))
       (setq-default pathname-coding-system 'utf-8)
       (set-file-name-coding-system 'utf-8)
       (setq auto-save-default nil)
       (show-paren-mode t))

(defun config-gui ()
  "Config guis."

  (make-face 'speedbar-face)
  (setq speedbar-use-images nil)
  (global-visual-line-mode 1)
  (nyan-mode t)
  (nyan-start-animation)
  (eval-after-load "auto-complete" '(diminish 'auto-complete-mode))
  (eval-after-load "flycheck" '(diminish 'flycheck-mode))
  (eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
  (global-prettify-symbols-mode 1)
  (global-hl-line-mode t)
  (global-auto-highlight-symbol-mode t)
  (setq ahs-idle-interval 0.5)
  (defun pretty-lambdas-haskell ()
    (font-lock-add-keywords
     nil `((,(concat "\\(" (regexp-quote "\\") "\\)")
	    (0 (progn (compose-region (match-beginning 1) (match-end 1)
				      ,(make-char 'greek-iso8859-7 107))
		      nil))))))
  (defun sm-greek-lambda ()
    (font-lock-add-keywords nil `(("\\<lambda\\>"
				   (0 (progn (compose-region (match-beginning 0) (match-end 0)
							     ,(make-char 'greek-iso8859-7 107))
					     nil))))))
  (add-hook 'haskell-mode-hook 'pretty-lambdas-haskell)
  (add-hook 'python-mode-hook 'sm-greek-lambda)
  (set-face-attribute 'default nil :height 130)
  (set-face-attribute 'default nil :weight `bold)
  (set-frame-parameter (selected-frame) 'alpha (list 100 100))
  (setq alpha-list '((90 90) (70 70)))
  (defun loop-alpha ()
    (interactive)
    (let ((h (car alpha-list)))
      ((lambda (a ab)
	 (set-frame-parameter (selected-frame) 'alpha (list a ab))
	 (add-to-list 'default-frame-alist (cons 'alpha (list a ab))))
       (car h) (car (cdr h)))
      (setq alpha-list (cdr (append alpha-list (list h))))))

  (global-linum-mode t)
  (fset 'yes-or-no-p 'y-or-n-p)
  (desktop-save-mode t)
  (setq tabbar-ruler-global-tabbar t)    ; get tabbar
  (setq tabbar-ruler-global-ruler nil)     ; get global ruler
  (setq tabbar-ruler-popup-menu t)       ; get popup menu.
  (setq tabbar-ruler-popup-toolbar t)    ; get popup toolbar
  (setq tabbar-ruler-global-tabbar t) ; If you want tabbar

  (require 'tabbar-ruler)
  (show-paren-mode t)
  (if window-system
      (progn
	(set-fontset-font "fontset-default"
			  'gb18030 '("Hei" . "unicode-bmp"))
	(setq monokai-theme-kit t)
	(set-face-background 'region "orange")
	(load-theme 'monokai t))
    (progn
      ))
  (powerline-default-theme)
  (setq powerline-default-separator 'alternate)
  )


(defun config-auto-mode ()
  (ido-mode 1)
  (whitespace-cleanup-mode 1)
  (require 'neotree)
  (setq neo-window-width 28)
  (add-to-list 'auto-mode-alist '("\\.mkd" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
  (add-to-list 'auto-mode-alist '("\\.elm$" . elm-mode))
  (add-to-list 'auto-mode-alist '("\\.es6$" . js-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx$" . js-mode))
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
  (eval-after-load 'company
    '(progn
       (define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
       (define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1)))))

  ;;     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  ;;    (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))
  (add-hook 'after-init-hook 'global-company-mode)
  (add-hook
   'eshell-mode-hook
   (lambda()
     (outline-or-mode 1)
     ))

  (add-hook
   'org-mode-hook
   (lambda ()
     (local-set-key [C-tab] 'other-window)))

  (add-hook
   'find-file-hook  ;; save the sudo files
   (lambda ()
     (if (not indent-tabs-mode)
	 (set (make-local-variable 'whitespace-action)
	      '(auto-cleanup)))))

  (add-hook 'after-init-hook 'global-flycheck-mode)
  (add-hook 'python-mode-hook 'flymake-mode)
  (setq jedi:complete-on-dot t)                 ; optional
  (add-hook 'python-mode-hook 'jedi:setup)
  (elpy-enable)
  (electric-pair-mode t))

(defun config-shells()
  ;;  (defvar ac-source-eshell-pcomplete
  ;;      '((candidates . (pcomplete-completions))))
  ;;   (defun ac-complete-eshell-pcomplete ()
  ;;     (interactive)
  ;;     (auto-complete '(ac-source-eshell-pcomplete)))
  ;; ;;  (add-to-list 'ac-modes 'eshell-mode)
  ;;   (setq ac-sources '(ac-source-eshell-pcomplete))
  )

(defun config-evil-mode ()
  ;;  (setq evil-default-state 'emacs)
  (add-to-list 'evil-emacs-state-modes 'eshell-mode)
  (add-to-list 'evil-emacs-state-modes 'shell-mode)
  (add-to-list 'evil-emacs-state-modes 'term-mode)
  (add-to-list 'evil-emacs-state-modes 'org-mode)
  (add-to-list 'evil-emacs-state-modes 'multi-term-mode)
  (add-to-list 'evil-emacs-state-modes 'w3m)
  (add-to-list 'evil-emacs-state-modes 'markdown-mode)
  (add-to-list 'evil-emacs-state-modes 'neotree-mode)
  (setq evil-auto-indent t)
  (setq evil-shift-width 4)
  (setq evil-regexp-search t)
  (setq evil-want-C-i-jump t)
  (setq evil-want-C-u-scroll t)
  (evil-mode 1)
  )

(defun config-org-mode ()
  "Org Configures."
  (setq org-agenda-files (quote ("~/Notes"
				 "~/kbs"))))

(set-PATH)
(init-el-get my:el-get-packages)
(el-get 'sync my:el-get-packages)
(init-key-binding)
(config)
(config-gui)
(config-auto-mode)
(config-evil-mode)
(config-shells)
(config-org-mode)
(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(scroll-bar-mode nil)
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
