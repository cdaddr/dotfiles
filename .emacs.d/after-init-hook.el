
;; my custom stuff
;; (add-to-list 'load-path "~/.emacs.d/lisp")

(setq package-list '(ac-cider bar-cursor cider clojure-mode ido-ubiquitous ido-completing-read+ org org-ac auto-complete-pcmp log4e auto-complete paredit pkg-info epl popup queue rainbow-delimiters seq spinner undo-tree yaxception))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(set-language-environment "UTF-8")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'gentooish t)

(setq frame-title-format '(multiple-frames "%b" ("" invocation-name)))
(if (string= window-system "w32")
    (set-default-font "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso859-1")
    (set-default-font "Consolas-14" t))

(defun my-backward-kill-word ()
  "Kill words backward my way."
  (interactive)
  (if (bolp)
      (backward-delete-char 1)
    (if (string-match "^\\s-+$" (buffer-substring (point-at-bol) (point)))
        (kill-region (point-at-bol) (point))
      (backward-kill-word 1))))

(global-set-key "\C-\M-j" 'copy-sexp)
(defun copy-sexp (&optional arg)
  (interactive "p")
  (save-excursion
    (let ((opoint (point)))
      (forward-sexp (or arg 1))
      (kill-ring-save opoint (point)))))

(fset 'yes-or-no-p 'y-or-n-p)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'control)

(global-set-key "\C-R" 'undo-tree-redo)
(global-set-key "\M-\d" 'my-backward-kill-word)
(global-set-key "\C-o" 'point-undo)

(global-set-key "\C-m" 'reindent-then-newline-and-indent)  ;No tabs
(global-set-key "\C-a" 'beginning-of-line-text)

(global-set-key [C-tab] 'indent-according-to-mode)

(setq transient-mark-mode t)
(setq mouse-drag-copy-region nil)
(setq x-select-enable-primary nil)
(setq x-select-enable-clipboard t)
(setq select-active-regions t)
(global-set-key [mouse-2] 'mouse-yank-primary)

(setq linum-format "%3d ")
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)

(setq line-number-mode nil)
(setq column-number-mode nil)
(setq size-indication-mode nil)
(setq vc-handled-backends nil)

(setq case-fold-search t)
(setq inhibit-startup-screen t)

(setq require-final-newline t)

(savehist-mode t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
(windmove-default-keybindings 'meta)



(tooltip-mode nil)

(tooltip-mode nil)
(tool-bar-mode 0)
(delete-selection-mode t)
(winner-mode t)
(cua-mode t)
(global-linum-mode t)
(global-undo-tree-mode)


(global-set-key "\C-xK" 'kill-all-buffers)
(defun kill-all-buffers ()
  (interactive)
  (when (y-or-n-p "Kill all buffers?")
    (dolist (buf (buffer-list))
      (kill-buffer buf))
    (delete-other-windows)))

(defun make-backup-file-name (file)
  (concat "~/.backups/" (file-name-nondirectory file) "~"))

; mode line
(setq mode-line-format
 (quote
  ("%e--[" mode-line-buffer-identification "]"
   (vc-mode vc-mode)
   "  " mode-line-modes global-mode-string " %-")))
(setq mode-line-in-non-selected-windows t)
(setq mode-line-modes
 (quote
  ("%[" "("
   (:propertize
    ("" mode-name))
   ("" mode-line-process)
   (:propertize
    ("" minor-mode-alist))
   "%n" ")" "%]")))

(show-paren-mode 1)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(setq ido-decorations
      (quote
       ("" "" " | " " | ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; scrolling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq scroll-bar-mode nil)
(setq scroll-conservatively 100000)
(setq scroll-down-aggressively 0.0)
(setq scroll-margin 0)
(setq scroll-step 1)
(setq scroll-up-aggressively 0.0)
(setq mouse-wheel-progressive-speed nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make emacs more like vim
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; search for word under point, like Vim
;; from http://stackoverflow.com/questions/589691/how-can-i-emulate-vims-search-in-gnu-emacs
(global-set-key [M-kp-multiply] 'my-isearch-word-at-point)
(defun my-isearch-word-at-point ()
  (interactive)
  (call-interactively 'isearch-forward-regexp))

(add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)
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

; search from beginning of file until end
(defun replace-globally ()
  "Run replace-regexp across the whole file, rather than from
point to the end of the file."
  (interactive)
  (let ((before (point)))
    (goto-char (point-min))
    (call-interactively 'replace-regexp)
    (when (= (point) (point-min))
      (goto-char before))))

; wrap search past end
(setq isearch-search-fun-function 'wrapping-search)
(defun wrapping-search ()
  (lambda (&rest args)
    (let* ((isearch-search-fun-function nil)
           (fun (isearch-search-fun)))
      (or (apply fun args)
          (unless (cadr args)
            (goto-char (if isearch-forward (point-min) (point-max)))
            (apply fun args))))))

; open line above/below
;; from http://stackoverflow.com/questions/2173324/emacs-equivalents-of-vims-dd-o-o
(global-set-key "\M-O" 'open-line-above)
(defun open-line-above ()
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key "\M-o" 'open-line-below)
(defun open-line-below ()
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

; paste line above/below
(global-set-key "\M-P" 'yank-as-line-above)
(global-set-key "\M-p" 'yank-as-line-below)
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


;; Prevent Emacs from stupidly auto-changing my working directory
(global-set-key "\C-x\C-f" 'find-file-save-default-directory)
(defun find-file-save-default-directory ()
    (interactive)
    (setq saved-default-directory default-directory)
    (ido-find-file)
    (setq default-directory saved-default-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; saveplace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'saveplace)
(setq save-place-file "~/.emacs.d/saveplace")
(setq save-place t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; autocomplete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(eval-after-load "auto-complete"
  '(progn
     (define-key ac-completing-map [down] nil)
     (define-key ac-completing-map [up] nil)
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)))

;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq completion-at-point-functions '(auto-complete)))
;;  
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)
;;  
;; (setq ac-auto-show-menu nil)
;; (setq ac-show-menu-immediately-on-auto-complete nil)
;; (setq ac-use-quick-help nil)
;; (setq ac-auto-start 1)
;; (setq ac-delay 0.0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; paredit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'paredit-mode-hook
          (lambda ()
            ;; Some paredit keybindings conflict with windmove and SLIME
            (define-key paredit-mode-map (kbd "<M-up>") nil)
            (define-key paredit-mode-map (kbd "<M-down>") nil)
            (define-key paredit-mode-map "\M-r" nil)
            (define-key paredit-mode-map "{" 'paredit-open-curly)
            (define-key paredit-mode-map "}" 'paredit-close-curly)
            (define-key paredit-mode-map "\M-[" 'paredit-wrap-square)
            (define-key paredit-mode-map "\M-{" 'paredit-wrap-curly)
            (modify-syntax-entry ?\{ "(}")
            (modify-syntax-entry ?\} "){")
            ))

(add-hook 'prog-mode-hook 'paredit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bar-cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq-default cursor-type 'bar)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cider
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq cider-stacktrace-frames-background-color "#171717")
(add-hook 'clojure-mode-hook 'auto-complete-mode)

(setq cider-repl-history-file "~/.emacs.d/cider-history.log")
(add-hook 'cider-repl-mode-hook 'subword-mode)
(setq nrepl-hide-special-buffers t)
(setq cider-prefer-local-resources t)
;; (setq cider-repl-pop-to-buffer-on-connect nil)
(setq cider-show-error-buffer nil)
(setq cider-stacktrace-default-filters '(tooling dup repl java))
(setq cider-repl-display-in-current-window t)
(setq cider-prompt-save-file-on-load nil)
(setq cider-repl-history-size 10000)

(defun clojure () (interactive) (cider-jack-in nil))

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; css
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun electric-brace (arg)
  (interactive "P")
    ;; insert a brace
  (self-insert-command 1)
  ;; maybe do electric behavior
  (css-indent-line))
(add-hook 'css-mode-hook (lambda () (define-key css-mode-map "}" 'electric-brace)))

