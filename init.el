;;; UI Config
;; We want to set these as soon as possible during init so Emacs doesn't load them in the first place

;;Don't show scroll bar / toolbar
(dolist (mode '(scroll-bar-mode tool-bar-mode))
  (when (fboundp mode)
    (funcall mode -1)))

;; Don't show splash screen / startup screen
(setq inhibit-splash-screen t
      inhibit-startup-screen t)

;;; Package Setup
(package-initialize)

(setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(defconst user-packages
  '(ac-cider		            ; auto-complete <-> cider
    aggressive-indent	            ; automatically keep things indented
    auto-complete	            ; auto-completion
    clojure-mode-extra-font-locking ; extra keyword highlighting for Clojure files
    cider		            ; Clojure Interactive Development Environment that Rocks
    highlight-parentheses           ; Highlight matching parentheses
    paredit		            ; Keep parentheses matched
    rainbow-delimiters))            ; Highlight matching parens in different colors

(defvar user-has-refreshed-packages-p nil)
(dolist (package user-packages)
  (unless (package-installed-p package)
    ;; Fetch updated list of packages from the archives one time only
    (unless user-has-refreshed-packages-p
      (ignore-errors
	(package-refresh-contents))
      (setq user-has-refreshed-packages-p t))
    (package-install package))
  ;; Go ahead and require all the packages now since we'll need them in a sec anyway
  (require package))


;;; Global config

(delete-selection-mode 1)   ; typing will delete selected text
(ido-mode 1)		    ; auto-complete for switching files, etc.
(global-auto-revert-mode 1) ; automatically reload files when they change on disk
(global-eldoc-mode 1)	    ; show documentation for current fn in minibuffer


;;; Auto-complete configuration

(setq ac-auto-show-menu 0.1
      ac-candidate-menu-height 20
      ac-candidate-menu-min 0
      ac-delay 0.05
      ac-quick-help-delay 0.2)

(defun user-auto-complete-config ()
  (ac-config-default)
  (add-to-list 'ac-modes 'cider-repl-mode))

(eval-after-load 'auto-complete
  '(user-auto-complete-config))


;;; Lisp major modes configuration

(defun user-lisp-mode-setup ()
  (aggressive-indent-mode 1)
  (auto-complete-mode 1)
  (highlight-parentheses-mode 1)
  (paredit-mode 1)
  (rainbow-delimiters-mode 1)
  (show-paren-mode 1))

(add-hook 'emacs-lisp-mode-hook #'user-lisp-mode-setup)


(setq cider-auto-select-error-buffer nil
      cider-repl-use-pretty-printing t)

(defun user-clojure-mode-setup ()
  (user-lisp-mode-setup)
  (ac-cider-setup))

(add-hook 'clojure-mode-hook #'user-clojure-mode-setup)
(add-hook 'cider-repl-mode-hook #'user-clojure-mode-setup)

(defun user-start-cider-repl-standalone (&rest _)
  "Start a cider repl with `cider-jack-in' and make it the sole buffer."
  (interactive)
  (setq cider-repl-display-in-current-window t)
  (cider-jack-in))

(add-to-list 'command-switch-alist '("cider" . user-start-cider-repl-standalone))


;;; Final setup
(toggle-frame-maximized) ; now make our window fullscreen


;;; Emacs will insert a bunch of custom-set- sutff below, great thanks
