;;; EMACS init file

;; Standard Emacs settings
; startup buffers
(setq inhibit-startup-message t)
(defun display-startup-echo-area-message ()
	(message "Emacs successfully loaded into memory. Hack away."))
(setq initial-scratch-message ";; *scratch* buffer
;; ----------------
;; Hey this is a scratch buffer. Go ahead - be crazy. I won't tell anyone.
;;
;; Common commands:
;;	M-x <exp>	run command
;;	C-x C-c		close up shop and go home
;;	C-x 0		close just this buffer (I am but naught)
;;	C-x 1		close all other buffers (make me the One)
;;	C-x o		switch to other (visible) buffer
;;	C-x <right>	switch to next buffer
;;	C-x <left>	switch to prev buffer
;;	C-x C-b		list all buffers

")
; replace 'yes' with 'y' and 'no' with 'n'
(fset 'yes-or-no-p 'y-or-n-p)
; search history
;(define-key nrepl-mode-map (kbd "<up>") 'nrepl-previous-input)
;(define-key nrepl-mode-map (kbd "<down>") 'nrepl-next-input)

;; Quicklisp settings
(load (expand-file-name "~/quicklisp/slime-helper.el"))

;; Slime
;(add-to-list 'load-path "/usr/share/emacs24/site-lisp/slime")
;(add-to-list 'load-path "/home/arno/installations/slime")
(require 'slime)
(slime-setup '(slime-fancy slime-banner))


;; Common Lisp
(setq inferior-lisp-program "sbcl")
;(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
;(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

;; Chicken Scheme
(setq scheme-program-name "csi")
(add-to-list 'load-path "/var/lib/chicken/6/")   ; Where Eggs are installed
(autoload 'chicken-slime "chicken-slime" "SWANK backend for Chicken" t)
;(setq swank-chicken-path "/var/lib/chicken/6/swank-chicken.scm")
;(setq swank-chicken-port 4015)
(add-hook 'scheme-mode-hook
		  (lambda ()
			(slime-mode t)))

