(mapcar (lambda (x) (add-to-list 'load-path (expand-file-name x)))
    '("~/.emacs.d"
      "~/.emacs.d/slime"
      "~/.emacs.d/clojure-mode"
      "~/.emacs.d/swank-clojure"))

(defun require-all (packages)
    (mapcar #'require packages))

(require-all '(
               uniquify
               light-symbol
               linum 
               color-theme
               ido
               parenface
               point-undo
               bar-cursor
               browse-kill-ring
               ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL
(browse-kill-ring-default-keybindings)

(defun my-backward-kill-word ()
  "Kill words backward my way."
  (interactive)
  (if (bolp)
      (backward-delete-char 1)
    (if (string-match "^\\s-+$" (buffer-substring (point-at-bol) (point)))
        (kill-region (point-at-bol) (point))
      (backward-kill-word 1))))

(global-set-key "\M-\d" 'my-backward-kill-word)

;; From http://stackoverflow.com/questions/848936/how-to-preserve-clipboard-content-in-emacs-on-windows
(defadvice kill-new (before kill-new-push-xselection-on-kill-ring activate)
  "Before putting new kill onto the kill-ring, add the clipboard/external selection to the kill ring"
  (let ((have-paste (and interprogram-paste-function
                         (funcall interprogram-paste-function))))
    (when have-paste (push have-paste kill-ring))))


(global-hi-lock-mode 1)

(defun my-isearch-word-at-point ()
  (interactive)
  (call-interactively 'isearch-forward-regexp))

(defun my-isearch-yank-word-hook ()
  (when (equal this-command 'my-isearch-word-at-point)
    (let ((string (concat "\\<"
                          (buffer-substring-no-properties
                           (progn (skip-syntax-backward "w_") (point))
                           (progn (skip-syntax-forward "w_") (point)))
                          "\\>")))
      (if (and isearch-case-fold-search
               (eq 'not-yanks search-upper-case))
          (setq string (downcase string)))
      (setq isearch-string string
            isearch-message
            (concat isearch-message
                    (mapconcat 'isearch-text-char-description
                               string ""))
            isearch-yank-flag t)
      (isearch-search-and-update))))

(add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)
(global-set-key [M-kp-multiply] 'my-isearch-word-at-point)

(global-set-key "\C-o" 'point-undo)
;;(global-set-key "\C-i" 'point-redo)

;; from http://stackoverflow.com/questions/589691/how-can-i-emulate-vims-search-in-gnu-emacs

(defun my-isearch-word-at-point ()
  (interactive)
  (call-interactively 'isearch-forward-regexp))

(defun my-isearch-yank-word-hook ()
  (when (equal this-command 'my-isearch-word-at-point)
    (let ((string (concat "\\<"
                          (buffer-substring-no-properties
                           (progn (skip-syntax-backward "w_") (point))
                           (progn (skip-syntax-forward "w_") (point)))
                          "\\>")))
      (if (and isearch-case-fold-search
               (eq 'not-yanks search-upper-case))
          (setq string (downcase string)))
      (setq isearch-string string
            isearch-message
            (concat isearch-message
                    (mapconcat 'isearch-text-char-description
                               string ""))
            isearch-yank-flag t)
      (isearch-search-and-update))))

(add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)
(global-set-key [M-kp-multiply] 'my-isearch-word-at-point)


(bar-cursor-mode 1)

;; Try to fix copy/paste
(setq-default mode-line-buffer-identification '(#("%2b" 0 2 (face mode-line-buffer-id))))
(setq transient-mark-mode t)
(setq mouse-drag-copy-region nil)
(setq x-select-enable-primary nil)
(setq x-select-enable-clipboard t)
(setq select-active-regions t)
(global-set-key [mouse-2] 'mouse-yank-primary)
(cua-mode t)

;; from http://www.emacswiki.org/emacs/AutoIndentation
(defadvice yank (after indent-region activate)
  (if (member major-mode '(emacs-lisp-mode lisp-mode))
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil)))) 

(delete-selection-mode t)
(tool-bar-mode 0)
(global-linum-mode)
(setq linum-format "%3d ")
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)
(winner-mode t)

(tooltip-mode nil)
(setq line-number-mode nil)
(setq column-number-mode nil)
(setq size-indication-mode nil)
(setq mode-line-position nil)
(ido-mode 1)

(global-set-key "\C-m" 'reindent-then-newline-and-indent)  ;No tabs
(global-set-key "\C-a" 'beginning-of-line-text)

(setq window-min-height 2)
(defun maximize-window ()
  (interactive)
  (let* ((other-windows (cdr (window-list)))
         (other-heights (* (length other-windows) window-min-height))
         (my-height (- (frame-height) other-heights)))
    (setf (window-height) (- my-height 1))))

(add-hook 'term-setup-hook (lambda () (windmove-default-keybindings 'meta)))
;(defadvice windmove-up (after maximize activate) (maximize-window))
;(defadvice windmove-down (after maximize activate) (maximize-window))

(set-fringe-style (cons 0 1))

(setq vc-handled-backends (remq 'Bzr vc-handled-backends))

(defun kill-all-buffers ()
  (interactive)
  (when (y-or-n-p "Kill all buffers?")
    (dolist (buf (buffer-list))
      (kill-buffer buf))
    (delete-other-windows)))
(global-set-key "\C-xK" 'kill-all-buffers)

(defun make-backup-file-name (file)
  (concat "~/.backups/" (file-name-nondirectory file) "~"))

(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
  point."
  (interactive "*P")
  (if (and
        (or (bobp) (= ?w (char-syntax (char-before))))
        (or (eobp) (not (= ?w (char-syntax (char-after))))))
    (dabbrev-expand arg)
    (indent-according-to-mode)))
(global-set-key [C-tab] 'indent-according-to-mode)

(defun tab-fix ()
  (local-set-key [tab] 'indent-or-expand))
(defun slime-tab-fix ()
  (local-set-key [tab] 'slime-complete-symbol))
(add-hook 'emacs-lisp-mode-hook 'tab-fix)
(add-hook 'lisp-mode-hook       'slime-tab-fix)

(setq auto-save-list-file-prefix nil)
(fset 'yes-or-no-p 'y-or-n-p)

;; Auto-wrap isearch
(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))

;; Prevent Emacs from stupidly auto-changing my working directory
(defun find-file-save-default-directory ()
    (interactive)
    (setq saved-default-directory default-directory)
    (ido-find-file)
    (setq default-directory saved-default-directory))
(global-set-key "\C-x\C-f" 'find-file-save-default-directory)

(require 'saveplace)
(setq save-place-file "~/.emacs.d/saveplace")
(setq save-place t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminals
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paredit

(require 'paredit)

;; This conflicts with windmove otherwise
(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "<M-up>") nil)
     (define-key paredit-mode-map (kbd "<M-down>") nil)))

(define-key paredit-mode-map (kbd ")")
            'paredit-close-parenthesis)
(define-key paredit-mode-map (kbd "M-)")
            'paredit-close-parenthesis-and-newline)

(enable-paredit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby

;(require 'ruby-mode)

;(define-key ruby-mode-map "\C-m" 'reindent-then-newline-and-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS

(defun electric-brace (arg)
  (interactive "P")
    ;; insert a brace
  (self-insert-command 1)
  ;; maybe do electric behavior
  (css-indent-line))

(require 'css-mode)
(define-key css-mode-map "}" 'electric-brace)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#171717" :foreground "#c0c0c0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 122 :width normal :foundry "microsoft" :family "Consolas"))))
 '(bold ((t (:foreground "white" :weight normal))))
 '(cursor ((t (:background "green"))))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background dark)) (:foreground "grey30" :slant italic))))
 '(hi-blue ((((background dark)) (:background "grey20"))))
 '(linum ((t (:inherit shadow :background "grey12"))))
 '(mode-line ((((class color) (min-colors 88)) (:background "#333333" :foreground "#ffffff" :box (:line-width -1 :color "#333333")))))
 '(mode-line-highlight ((((class color) (min-colors 88)) nil)))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background dark)) (:foreground "#8b8b8b" :weight light))))
 '(tool-bar ((default (:foreground "black")) (((type x w32 ns) (class color)) (:background "grey75")))))

(if (string= window-system "w32")
    (set-face-font 'default "-outline-Consolas-normal-r-normal-normal-14-112-96-96-c-*-iso8859-1")
  (set-default-font "Consolas-12" t))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(fancy-splash-image "")
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(lisp-loop-forms-indentation 6)
 '(lisp-loop-keyword-indentation 6)
 '(lisp-simple-loop-indentation 6)
 '(mode-line-format (quote ("%e--[" mode-line-buffer-identification "]" (vc-mode vc-mode) "  " mode-line-modes global-mode-string " %-")))
 '(mode-line-in-non-selected-windows t)
 '(mode-line-modes (quote ("%[" "(" (:propertize ("" mode-name)) ("" mode-line-process) (:propertize ("" minor-mode-alist)) "%n" ")" "%]")))
 '(mouse-wheel-progressive-speed nil)
 '(require-final-newline t)
 '(savehist-mode t nil (savehist))
 '(scroll-bar-mode nil)
 '(scroll-conservatively 100000)
 '(scroll-down-aggressively 0.0)
 '(scroll-margin 0)
 '(scroll-step 1)
 '(scroll-up-aggressively 0.0)
 '(show-paren-mode t nil (paren))
 '(slime-compilation-finished-hook nil)
 '(swank-clojure-extra-classpaths (quote ("~/.emacs.d/swank-clojure/src")))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure / SLIME

(require 'swank-clojure-autoload)
(if (string= window-system "w32")
 (swank-clojure-config
  ;;(setq swank-clojure-jar-path "c:/lisp/clojure/clojure.jar")
  ;;(setq swank-clojure-extra-vm-args (list "-Djdbc.drivers=sun.jdbc.odbc.JdbcOdbcDriver"))
  ;;(setq swank-clojure-extra-classpaths (list "c:/lisp/clojure-contrib/clojure-contrib.jar" "c:/lisp/mysql-connector-java-5.1.7-bin.jar")))
  (setq swank-clojure-binary "c:/utils/clojure.bat"))
 (setq swank-clojure-binary "~/local/bin/clojure"))

(require-all '(
               slime
               clojure-mode
              ))

(setq slime-net-coding-system 'utf-8-unix)

(setq auto-mode-alist
      (cons '("\\.clj$" . clojure-mode)
            auto-mode-alist))

(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix) 
(slime-setup '(slime-fancy))
(define-key clojure-mode-map (kbd "<tab>") 'indent-or-expand)
(add-hook 'slime-connected-hook 'slime-redirect-inferior-output) 

(defun lisp-enable-paredit-hook () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'lisp-enable-paredit-hook)

(defface clojure-parens '((((class color)) (:foreground "DimGrey"))) "Clojure parens" :group 'faces)
(defface clojure-braces '((((class color)) (:foreground "LightSlateGrey"))) "Clojure braces" :group 'faces)
(defface clojure-brackets '((((class color)) (:foreground "SteelBlue"))) "Clojure brackets" :group 'faces)
(defface clojure-keyword '((((class color)) (:foreground "khaki"))) "Clojure keywords" :group 'faces)

(defun tweak-clojure-syntax ()
  (font-lock-add-keywords nil '(("(\\|)" . 'clojure-parens)))
  (font-lock-add-keywords nil '(("{\\|}" . 'clojure-brackets)))
  (font-lock-add-keywords nil '(("\\[\\|\\]" . 'clojure-braces)))
  (font-lock-add-keywords nil '((":\\w+" . 'clojure-keyword))))

(add-hook 'clojure-mode-hook 'tweak-clojure-syntax)
(add-hook 'slime-repl-mode-hook (lambda ()
                                  (enable-paredit-mode)
                                  (tweak-clojure-syntax)))

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

;;(add-to-list 'slime-lisp-implementations '(sbcl ("/usr/bin/sbcl")))

