;;; zencoding-mode.el --- Unfold CSS-selector-like expressions to markup

;; Copyright (C) 2009, Chris Done

;; Author: Chris Done <chrisdone@gmail.com>
;; Keywords: convenience

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Unfold CSS-selector-like expressions to markup. Intended to be used
;; with sgml-like languages; xml, html, xhtml, xsl, etc.

;; Copy zencoding-mode.el to your load-path and add to your .emacs:

;;    (require 'zencoding-mode)

;; Example setup:

;;    (add-to-list 'load-path "~/Emacs/zencoding/")
;;    (require 'zencoding-mode)
;;    (add-hook 'sgml-mode-hook 'zencoding-mode) ;; Auto-start on any markup modes

;; Enable the minor mode with M-x zencoding-mode.

;; See ``Test cases'' section for a complete set of expression types.

;; If you are hacking on this project, eval (zencoding-test-cases) to
;; ensure that your changes have not broken anything. Feel free to add
;; new test cases if you add new features.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generic parsing macros and utilities

(defmacro zencoding-aif (test-form then-form &rest else-forms)
  "Anaphoric if. Temporary variable `it' is the result of test-form."
  `(let ((it ,test-form))
     (if it ,then-form ,@(or else-forms '(it)))))

(defmacro zencoding-pif (test-form then-form &rest else-forms)
  "Parser anaphoric if. Temporary variable `it' is the result of test-form."
  `(let ((it ,test-form))
     (if (not (eq 'error (car it))) ,then-form ,@(or else-forms '(it)))))

(defmacro zencoding-parse (regex nums label &rest body)
  "Parse according to a regex and update the `input' variable."
  `(zencoding-aif (zencoding-regex ,regex input ',(number-sequence 0 nums))
                  (let ((input (elt it ,nums)))
                    ,@body)
                  `,`(error ,(concat "expected " ,label))))

(defmacro zencoding-run (parser then-form &rest else-forms)
  "Run a parser and update the input properly, extract the parsed
   expression."
  `(zencoding-pif (,parser input)
                  (let ((input (cdr it))
                        (expr (car it)))
                    ,then-form)
                  ,@(or else-forms '(it))))

(defmacro zencoding-por (parser1 parser2 then-form &rest else-forms)
  "OR two parsers. Try one parser, if it fails try the next."
  `(zencoding-pif (,parser1 input)
                  (let ((input (cdr it))
                        (expr (car it)))
                    ,then-form)
                  (zencoding-pif (,parser2 input)
                                 (let ((input (cdr it))
                                       (expr (car it)))
                                   ,then-form)
                                 ,@else-forms)))

(defun zencoding-regex (regexp string refs)
  "Return a list of (`ref') matches for a `regex' on a `string' or nil."
  (if (string-match (concat "^" regexp "\\(.*\\)$") string)
      (mapcar (lambda (ref) (match-string ref string)) 
              (if (sequencep refs) refs (list refs)))
    nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Zen coding parsers

(defun zencoding-expr (input)
  "Parse a zen coding expression. This pretty much defines precedence."
  (zencoding-run zencoding-siblings
                 it
                 (zencoding-run zencoding-parent-child
                                it
                                (zencoding-run zencoding-multiplier
                                               it
                                               (zencoding-run zencoding-pexpr
                                                              it
                                                              (zencoding-run zencoding-tag
                                                                             it
                                                                             '(error "no match, expecting ( or a-zA-Z0-9")))))))

(defun zencoding-multiplier (input)
  (zencoding-por zencoding-pexpr zencoding-tag
                 (let ((multiplier expr))
                   (zencoding-parse "\\*\\([0-9]+\\)" 2 "*n where n is a number"
                                    (let ((multiplicand (read (elt it 1))))
                                      `((list ,(make-list multiplicand multiplier)) . ,input))))
                 '(error "expected *n multiplier")))

(defun zencoding-tag (input)
  "Parse a tag."
  (zencoding-run zencoding-tagname
                 (let ((result it) 
                       (tagname (cdr expr)))
                   (zencoding-pif (zencoding-run zencoding-identifier
                                                 (zencoding-tag-classes
                                                  `(tag ,tagname ((id ,(cddr expr)))) input)
                                                 (zencoding-tag-classes `(tag ,tagname ()) input))
                                  (let ((expr-and-input it) (expr (car it)) (input (cdr it)))
                                    (zencoding-pif (zencoding-tag-props expr input)
                                                   it
                                                   expr-and-input))))
                 '(error "expected tagname")))

(defun zencoding-tag-props (tag input)
  (zencoding-run zencoding-props
                 (let ((tagname (cadr tag))
                       (existing-props (caddr tag))
                       (props (cdr expr)))
                   `((tag ,tagname 
                          ,(append existing-props props))
                     . ,input))))

(defun zencoding-props (input)
  "Parse many props."
    (zencoding-run zencoding-prop
                   (zencoding-pif (zencoding-props input)
                                  `((props . ,(cons expr (cdar it))) . ,(cdr it))
                                  `((props . ,(list expr)) . ,input))))

(defun zencoding-prop (input)
  (zencoding-parse 
   " " 1 "space"
   (zencoding-run
    zencoding-name
    (let ((name (cdr expr)))
      (zencoding-parse "=\\([^\\,\\+\\>\\ )]*\\)" 2 
                       "=property value"
                       (let ((value (elt it 1))
                             (input (elt it 2)))
                         `((,(read name) ,value) . ,input)))))))

(defun zencoding-tag-classes (tag input)
  (zencoding-run zencoding-classes
                 (let ((tagname (cadr tag)) 
                       (props (caddr tag))
                       (classes `(class ,(mapconcat 
                                          (lambda (prop)
                                            (cdadr prop))
                                          (cdr expr)
                                          " "))))
                   `((tag ,tagname ,(append props (list classes))) . ,input))
                 `(,tag . ,input)))

(defun zencoding-tagname (input)
  "Parse a tagname a-zA-Z0-9 tagname (e.g. html/head/xsl:if/br)."
  (zencoding-parse "\\([a-zA-Z][a-zA-Z0-9:-]*\\)" 2 "tagname, a-zA-Z0-9"
                   `((tagname . ,(elt it 1)) . ,input)))

(defun zencoding-pexpr (input)
  "A zen coding expression with parentheses around it."
  (zencoding-parse "(" 1 "("
                   (zencoding-run zencoding-expr
                                  (zencoding-aif (zencoding-regex ")" input '(0 1))
                                                 `(,expr . ,(elt it 1))
                                                 '(error "expecting `)'")))))

(defun zencoding-parent-child (input)
  "Parse an tag>e expression, where `n' is an tag and `e' is any 
   expression."
  (zencoding-run zencoding-multiplier
                 (let* ((items (cadr expr))
                        (rest (zencoding-child-sans expr input)))
                   (if (not (eq (car rest) 'error))
                       (let ((child (car rest))
                             (input (cdr rest)))
                         (cons (cons 'list
                                     (cons (mapcar (lambda (parent)
                                                     `(parent-child ,parent ,child))
                                                   items)
                                           nil))
                               input))
                     '(error "expected child")))
                 (zencoding-run zencoding-tag
                                (zencoding-child expr input)
                                '(error "expected parent"))))

(defun zencoding-child-sans (parent input)
  (zencoding-parse ">" 1 ">"
                   (zencoding-run zencoding-expr
                                  it
                                  '(error "expected child"))))

(defun zencoding-child (parent input)
  (zencoding-parse ">" 1 ">"
                   (zencoding-run zencoding-expr
                                  (let ((child expr))
                                    `((parent-child ,parent ,child) . ,input))
                                  '(error "expected child"))))

(defun zencoding-sibling (input)
  (zencoding-por zencoding-pexpr zencoding-multiplier
                 it
                 (zencoding-run zencoding-tag
                                it
                                '(error "expected sibling"))))

(defun zencoding-siblings (input)
  "Parse an e+e expression, where e is an tag or a pexpr."
  (zencoding-run zencoding-sibling
                 (let ((parent expr))
                   (zencoding-parse "\\+" 1 "+"
                                    (zencoding-run zencoding-expr
                                                   (let ((child expr))
                                                     `((zencoding-siblings ,parent ,child) . ,input))
                                                   '(error "expected second sibling"))))
                 '(error "expected first sibling")))

(defun zencoding-name (input)
  "Parse a class or identifier name, e.g. news, footer, mainimage"
  (zencoding-parse "\\([a-zA-Z][a-zA-Z0-9-_]*\\)" 2 "class or identifer name"
                   `((name . ,(elt it 1)) . ,input)))

(defun zencoding-class (input)
  "Parse a classname expression, e.g. .foo"
  (zencoding-parse "\\." 1 "."
                   (zencoding-run zencoding-name 
                                  `((class ,expr) . ,input)
                                  '(error "expected class name"))))

(defun zencoding-identifier (input)
  "Parse an identifier expression, e.g. #foo"
  (zencoding-parse "#" 1 "#"
                   (zencoding-run zencoding-name
                                  `((identifier . ,expr) . ,input))))

(defun zencoding-classes (input)
  "Parse many classes."
  (zencoding-run zencoding-class
                 (zencoding-pif (zencoding-classes input)
                                `((classes . ,(cons expr (cdar it))) . ,(cdr it))
                                `((classes . ,(list expr)) . ,input))
                 '(error "expected class")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Zen coding transformer from AST to HTML

(defun zencoding-make-tag (tag &optional content) 
  (let ((name (car tag))
        (props (apply 'concat (mapcar
                               (lambda (prop)
                                 (concat " " (symbol-name (car prop))
                                         "=\"" (cadr prop) "\""))
                               (cadr tag)))))
    (concat "<" name props ">" 
            (if content content "")
            "</" name ">")))

(defun zencoding-transform (ast)
  (let ((type (car ast)))
    (cond
     ((eq type 'list)
      (mapconcat 'zencoding-transform (cadr ast) ""))
     ((eq type 'tag)
      (zencoding-make-tag (cdr ast)))
     ((eq type 'parent-child)
      (let ((parent (cdadr ast))
            (children (zencoding-transform (caddr ast))))
        (zencoding-make-tag parent children)))
     ((eq type 'zencoding-siblings)
      (let ((sib1 (zencoding-transform (cadr ast)))
            (sib2 (zencoding-transform (caddr ast))))
        (concat sib1 sib2))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test-cases

(defun zencoding-test-cases ()
  (let ((tests '(;; Tags
                 ("a"                      "<a></a>")
                 ("a.x"                    "<a class=\"x\"></a>")
                 ("a#q.x"                  "<a id=\"q\" class=\"x\"></a>")
                 ("a#q.x.y.z"              "<a id=\"q\" class=\"x y z\"></a>")
                 ;; Siblings
                 ("a+b"                    "<a></a><b></b>")
                 ("a+b+c"                  "<a></a><b></b><c></c>")
                 ("a.x+b"                  "<a class=\"x\"></a><b></b>")
                 ("a#q.x+b"                "<a id=\"q\" class=\"x\"></a><b></b>")
                 ("a#q.x.y.z+b"            "<a id=\"q\" class=\"x y z\"></a><b></b>")
                 ("a#q.x.y.z+b#p.l.m.n"    "<a id=\"q\" class=\"x y z\"></a><b id=\"p\" class=\"l m n\"></b>")
                 ;; Parent > child
                 ("a>b"                    "<a><b></b></a>")
                 ("a>b>c"                  "<a><b><c></c></b></a>")
                 ("a.x>b"                  "<a class=\"x\"><b></b></a>")
                 ("a#q.x>b"                "<a id=\"q\" class=\"x\"><b></b></a>")
                 ("a#q.x.y.z>b"            "<a id=\"q\" class=\"x y z\"><b></b></a>")
                 ("a#q.x.y.z>b#p.l.m.n"    "<a id=\"q\" class=\"x y z\"><b id=\"p\" class=\"l m n\"></b></a>")
                 ("a>b+c"                  "<a><b></b><c></c></a>")
                 ("a>b+c>d"                "<a><b></b><c><d></d></c></a>")
                 ;; Multiplication
                 ("a*1"                    "<a></a>")
                 ("a*2"                    "<a></a><a></a>")
                 ("a*2+b*2"                "<a></a><a></a><b></b><b></b>")
                 ("a*2>b*2"                "<a><b></b><b></b></a><a><b></b><b></b></a>")
                 ("a>b*2"                  "<a><b></b><b></b></a>")
                 ("a#q.x>b#q.x*2"          "<a id=\"q\" class=\"x\"><b id=\"q\" class=\"x\"></b><b id=\"q\" class=\"x\"></b></a>")
                 ;; Properties
                 ("a x=y"                  "<a x=\"y\"></a>")
                 ("a x=y m=l"              "<a x=\"y\" m=\"l\"></a>")
                 ("a#foo x=y m=l"          "<a id=\"foo\" x=\"y\" m=\"l\"></a>")
                 ("a.foo x=y m=l"          "<a class=\"foo\" x=\"y\" m=\"l\"></a>")
                 ("a#foo.bar.mu x=y m=l"   "<a id=\"foo\" class=\"bar mu\" x=\"y\" m=\"l\"></a>")
                 ("a x=y+b"                "<a x=\"y\"></a><b></b>")
                 ("a x=y+b x=y"            "<a x=\"y\"></a><b x=\"y\"></b>")
                 ("a x=y>b"                "<a x=\"y\"><b></b></a>")
                 ("a x=y>b x=y"            "<a x=\"y\"><b x=\"y\"></b></a>")
                 ("a x=y>b x=y+c x=y"      "<a x=\"y\"><b x=\"y\"></b><c x=\"y\"></c></a>")
                 ;; Parentheses
                 ("(a)"                    "<a></a>")
                 ("(a)+(b)"                "<a></a><b></b>")
                 ("a>(b)"                  "<a><b></b></a>")
                 ("(a>b)>c"                "<a><b></b></a>")
                 ("(a>b)+c"                "<a><b></b></a><c></c>")
                 ("z+(a>b)+c+k"            "<z></z><a><b></b></a><c></c><k></k>")
                 ("(a)*2"                  "<a></a><a></a>")
                 ("((a)*2)"                "<a></a><a></a>")
                 ("((a)*2)"                "<a></a><a></a>")
                 ("(a>b)*2"                "<a><b></b></a><a><b></b></a>")
                 ("(a+b)*2"                "<a></a><b></b><a></a><b></b>")
                 )))
    (mapcar (lambda (input)
              (let ((expected (cadr input))
                    (actual (zencoding-transform (car (zencoding-expr (car input))))))
                (if (not (equal expected actual))
                    (error (concat "Assertion " (car input) " failed:"
                                   expected
                                   " == "
                                   actual)))))
            tests)
    (concat (number-to-string (length tests)) " tests performed. All OK.")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Zencoding minor mode

(defun zencoding-expand-line ()
  "Replace the current line's zencode expression with the corresponding expansion."
  (interactive)
  (let* ((line-start (line-beginning-position)) 
         (line
          (buffer-substring-no-properties line-start (line-end-position)))
         (match (zencoding-regex "\\([ \t]*\\)\\(.+\\)" line '(0 1 2)))
         (indentation (elt match 1))
         (expr (elt match 2)))
    (if expr 
          (let* ((markup (zencoding-transform (car (zencoding-expr expr))))
                 (markup-filled (replace-regexp-in-string "><" ">\n<" markup)))
            (message (concat "Expanded: " expr))
            (save-excursion
              (delete-region line-start (line-end-position))
              (insert markup-filled)
              (indent-region line-start (+ line-start (length markup-filled))))))))

(defvar zencoding-mode-keymap nil
  "Keymap for zencode minor mode.")

(if zencoding-mode-keymap
    nil
  (progn
    (setq zencoding-mode-keymap (make-sparse-keymap))
    (define-key zencoding-mode-keymap (kbd "<C-return>") 'zencoding-expand-line)))

(define-minor-mode zencoding-mode "Minor mode to assist writing markup."
  :lighter " Zen"
  :keymap zencoding-mode-keymap)

(provide 'zencoding-mode)