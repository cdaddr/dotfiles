;; fix exec-path

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq exec-path (append exec-path '("~/local/bin")))
(if (string= system-type "gnu/linux")
    (setenv "PATH" (concat (getenv "PATH")
                           ":~/local/bin")))

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(add-hook 'after-init-hook (lambda () (load "~/.emacs.d/after-init-hook.el")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu nil)
 '(ac-auto-start t)
 '(ac-show-menu-immediately-on-auto-complete nil)
 '(ac-trigger-key "TAB")
 '(ac-use-fuzzy t)
 '(cider-show-error-buffer (quote only-in-repl))
 '(package-selected-packages
   (quote
    (org-ac org undo-tree rainbow-delimiters paredit ido-ubiquitous bar-cursor ac-cider))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
