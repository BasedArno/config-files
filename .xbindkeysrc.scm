;;;;; Scheme API reference
;;;;
;; Optional modifier state:
;; (set-numlock! #f or #t)
;; (set-scrolllock! #f or #t)
;; (set-capslock! #f or #t)
;; 
;; Shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;; 
;; Scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;; 
;; Other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)

; bind shift + vertical scroll to horizontal scroll events
(xbindkey '(shift "b:4") "xte 'mouseclick 6'")
(xbindkey '(shift "b:5") "xte 'mouseclick 7'")

; lock command Win+L
(xbindkey '(Mod4 "l") "lock")

;(xbindkey-function '(Mod4 shift "o")
;	(lambda ()
;		("/home/arno/.config/herbstluftwm/savelayout.sh > /home/arno/.config/herbstluftwm/layout.txt")
;		("herbstclient reload")
;		("cat /home/arno/.config/herbstluftwm/layout.txt | /home/arno/.config/herbstluftwm/loadlayout.sh")))

;(xbindkey-function '(control a)
;		   (lambda ()
;		     (display "Hello from Scheme!")
;		     (newline)))

;; Chording keys test: Start differents program if only one key is
;; pressed or another if two keys are pressed.
;; If key1 is pressed start cmd-k1
;; If key2 is pressed start cmd-k2
;; If both are pressed start cmd-k1-k2 or cmd-k2-k1 following the
;;   release order
(define (define-chord-keys key1 key2 cmd-k1 cmd-k2 cmd-k1-k2 cmd-k2-k1)
    "Define chording keys"
  (let ((k1 #f) (k2 #f))
    (xbindkey-function key1 (lambda () (set! k1 #t)))
    (xbindkey-function key2 (lambda () (set! k2 #t)))
    (xbindkey-function (cons 'release key1)
		       (lambda ()
			 (if (and k1 k2)
			     (run-command cmd-k1-k2)
			     (if k1 (run-command cmd-k1)))
			 (set! k1 #f) (set! k2 #f)))
    (xbindkey-function (cons 'release key2)
		       (lambda ()
			 (if (and k1 k2)
			     (run-command cmd-k2-k1)
			     (if k2 (run-command cmd-k2)))
			 (set! k1 #f) (set! k2 #f)))))


;; Example:
;;   Shift + b:1                   start an xterm
;;   Shift + b:3                   start an rxvt
;;   Shift + b:1 then Shift + b:3  start gv
;;   Shift + b:3 then Shift + b:1  start xpdf

;(define-chord-keys '(shift "b:1") '(shift "b:3")
;  "xterm" "rxvt" "gv" "xpdf")
