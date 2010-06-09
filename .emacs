;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

(mapcar (lambda (x) (add-to-list 'load-path (expand-file-name x)))
        '("~/.emacs.d" "~/.emacs.d/clojure-mode" "~/.emacs.d/slime"))

(defun require-all (packages)
    (mapcar #'require packages))

(require-all '(
               uniquify
               light-symbol
               linum 
               color-theme
               gentooish
               ido
               parenface
               point-undo
               bar-cursor
               browse-kill-ring
               smart-tab
               ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL
(color-theme-initialize)

(if (string= window-system "w32")
    (set-default-font "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso859-1")
    (set-default-font "Consolas-12" t))

(if window-system
    (color-theme-gentooish)
    (color-theme-dark-laptop))

;; from http://joost.zeekat.nl/2010/06/03/slime-hints-3-interactive-completions-and-smart-tabs/
(setq smart-tab-completion-functions-alist
      '((emacs-lisp-mode . lisp-complete-symbol)
        (text-mode . dabbrev-completion)
        (clojure-mode . slime-complete-symbol)
        (slime-repl-mode . slime-complete-symbol)))

(global-smart-tab-mode 1)

(browse-kill-ring-default-keybindings)
(setq auto-save-list-file-prefix nil)
(fset 'yes-or-no-p 'y-or-n-p)

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

(setq vc-handled-backends nil)

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

(defun replace-globally ()
  "Run replace-regexp across the whole file, rather than from
point to the end of the file."
  (interactive)
  (let ((before (point)))
    (goto-char (point-min))
    (call-interactively 'replace-regexp)
    (when (= (point) (point-min))
      (goto-char before))))

(require 'saveplace)
(setq save-place-file "~/.emacs.d/saveplace")
(setq save-place t)

;; adapted from http://www.emacswiki.org/emacs/.emacs-ChristianRovner.el
(defun expand-region-linewise ()
  (interactive)
  (let ((start (region-beginning))
        (end (region-end)))
   (goto-char start)
   (beginning-of-line)
   (set-mark (point))
   (goto-char end)
   (unless (bolp) (end-of-line))))

(defun markdown-copy ()
  (interactive)
  (save-excursion
    (expand-region-linewise)
    (indent-rigidly (region-beginning) (region-end) 4)
    (clipboard-kill-ring-save (region-beginning) (region-end))
    (indent-rigidly (region-beginning) (region-end) -4)))

(defun yank-with-newline ()
  "Yank, appending a newline if the yanked text doesn't end with one."
  (yank)
  (when (not (string-match "\n$" (current-kill 0)))
    (newline-and-indent)))

(defun yank-as-line-above ()
  "Yank text as a new line above the current line.

Also moves point to the beginning of the text you just yanked."
  (interactive)
  (let ((lnum (line-number-at-pos (point))))
    (beginning-of-line)
    (yank-with-newline)
    (goto-line lnum)))

(defun yank-as-line-below ()
  "Yank text as a new line below the current line.

Also moves point to the beginning of the text you just yanked."
  (interactive)
  (let* ((lnum (line-number-at-pos (point)))
         (lnum (if (eobp) lnum (1+ lnum))))
    (if (and (eobp) (not (bolp)))
        (newline-and-indent)
      (forward-line 1))
    (yank-with-newline)
    (goto-line lnum)))

(global-set-key "\M-P" 'yank-as-line-above)
(global-set-key "\M-p" 'yank-as-line-below)

;; from http://stackoverflow.com/questions/2173324/emacs-equivalents-of-vims-dd-o-o
(defun open-line-above ()
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun open-line-below ()
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

(global-set-key "\M-O" 'open-line-above)
(global-set-key "\M-o" 'open-line-below)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminals
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paredit

(require 'paredit)

(eval-after-load 'paredit
  '(progn
     ;; Some paredit keybindings conflict with windmove and SLIME
     (define-key paredit-mode-map (kbd "<M-up>") nil)
     (define-key paredit-mode-map (kbd "<M-down>") nil)
     (define-key paredit-mode-map "\M-r" nil)))

(mapcar (lambda (hook) (add-hook hook 'enable-paredit-mode))
        '(clojure-mode-hook lisp-mode-hook slime-repl-mode-hook emacs-lisp-mode-hook))

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
;; Generic Lisp / Emacs Lisp
;; from http://www.emacswiki.org/emacs/AutoIndentation

(defadvice yank (after indent-region activate)
  (if (member major-mode '(clojure-mode emacs-lisp-mode lisp-mode))
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil)))) 

(defun tab-fix ()
  (local-set-key [tab] 'indent-or-expand))
(defun slime-tab-fix ()
  (local-set-key [tab] 'slime-complete-symbol))
(add-hook 'emacs-lisp-mode-hook 'tab-fix)
(add-hook 'lisp-mode-hook       'slime-tab-fix)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure / SLIME

(require 'clojure-mode)
(require 'slime)

(setq swank-clojure-jar-home "~/.emacs.d/swank-clojure/")
(add-to-list 'load-path "~/.emacs.d/swank-clojure")
(require 'swank-clojure)
(require 'clojure-test-mode)
(setq swank-clojure-classpath (append (swank-clojure-default-classpath)
                                      (list "." "src" "lib/*" "classes" "native" "/usr/local/lib/*")))
(setq swank-clojure-library-paths
      (if (string= window-system "w32")
          (list "native/windows/x86")
        (list "/usr/local/lib" "native/linux/x86")))
(setq swank-clojure-extra-vm-args (list "-Dfile.encoding=UTF8"))

(defadvice swank-clojure-reset-implementation (around default-clojure)
  (if (file-exists-p "lib")
      ad-do-it
    (let ((swank-clojure-classpath (append (swank-clojure-default-classpath)
                                           (list "src" "lib" "~/local/clojure/lib/*"))))
      ad-do-it)))
(ad-activate 'slime-read-interactive-args)
(ad-activate 'swank-clojure-reset-implementation)

;;(add-to-list 'slime-lisp-implementations '(sbcl ("/usr/bin/sbcl")))

(defvar slime-override-map (make-keymap))
(define-minor-mode slime-override-mode
  "Fix SLIME REPL keybindings"
  nil " SLIME-override" slime-override-map)
(define-key slime-override-map (kbd "<C-return>") 'paredit-newline)
(define-key slime-override-map (kbd "{") 'paredit-open-curly)
(define-key slime-override-map (kbd "}") 'paredit-close-curly)
(define-key slime-override-map [delete] 'paredit-forward-delete)
(define-key slime-override-map [backspace] 'paredit-backward-delete)
;;(define-key slime-override-map (kbd "<C-return>") 'paredit-newline)
;;(define-key slime-override-map "\C-j" 'slime-repl-return)

(add-hook 'slime-repl-mode-hook (lambda ()
                                  (slime-override-mode t)
                                  (slime-redirect-inferior-output)
                                  (modify-syntax-entry ?\[ "(]")
                                  (modify-syntax-entry ?\] ")[")
                                  (modify-syntax-entry ?\{ "(}")
                                  (modify-syntax-entry ?\} "){")))

(setq auto-mode-alist
      (cons '("\\.clj$" . clojure-mode)
            auto-mode-alist))

(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix) 
(slime-setup '(slime-repl slime-highlight-edits slime-fuzzy))
(define-key clojure-mode-map (kbd "<tab>") 'indent-or-expand)
(add-hook 'slime-connected-hook 'slime-redirect-inferior-output) 

(defun lisp-enable-paredit-hook () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'lisp-enable-paredit-hook)

(defmacro defclojureface (name color desc &optional others)
  `(defface ,name '((((class color)) (:foreground ,color ,@others))) ,desc :group 'faces))

(defclojureface clojure-parens       "DimGrey"   "Clojure parens")
(defclojureface clojure-braces       "#49b2c7"   "Clojure braces")
(defclojureface clojure-brackets     "SteelBlue" "Clojure brackets")
(defclojureface clojure-keyword      "khaki"     "Clojure keywords")
(defclojureface clojure-namespace    "#c476f1"   "Clojure namespace")
(defclojureface clojure-java-call    "#4bcf68"   "Clojure Java calls")
(defclojureface clojure-special      "#b8bb00"   "Clojure special")
(defclojureface clojure-double-quote "#b8bb00"   "Clojure special" (:background "unspecified"))

(defun tweak-clojure-syntax ()
  (mapcar (lambda (x) (font-lock-add-keywords nil x))
          '((("#?['`]*(\\|)"       . 'clojure-parens))
            (("#?\\^?{\\|}"        . 'clojure-brackets))
            (("\\[\\|\\]"          . 'clojure-braces))
            ((":\\w+"              . 'clojure-keyword))
            (("#?\""               0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1 'clojure-java-call))
            )))

(add-hook 'clojure-mode-hook 'tweak-clojure-syntax)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(clojure-mode-use-backtracking-indent t)
 '(comint-scroll-to-bottom-on-input t)
 '(fancy-splash-image "")
 '(global-linum-mode t)
 '(ido-decorations (quote ("" "" " | " " | ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
 '(ido-everywhere t)
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
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(slime-highlight-edits-face ((((class color) (background dark)) (:background "#202020")))))
