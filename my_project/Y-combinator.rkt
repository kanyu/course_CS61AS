#lang lazy
;; Y-comninator

;; use define
(define length
  (lambda (lst)
      (cond
        ((null? lst) 0)
        (else (add1 (length (cdr lst)))))))

;; test
(define alst '(1 2 3 4 5 6 7 8 9))
(length alst)

;; poor man Y
( ((lambda (leng)
     (lambda (lst)
       ;; (displayln lst)
       (cond
         ((null? lst) 0)
         (else (add1 ((leng leng) (cdr lst)))))))
   (lambda (leng)
     (lambda (lst)
       (displayln lst)
       (cond
         ((null? lst) 0)
         (else (add1 ((leng leng) (cdr lst))))))))
  alst)

;; abstract Y
(((lambda (f)
    ((lambda (x) (f (x x)))
     (lambda (x) (f (x x)))))
  (lambda (leng)
    (lambda (lst)
      (cond
        ((null? lst) 0)
        (else (add1 (leng (cdr lst))))))))
 alst)
(displayln alst)


((λ (x) (+ 3 x))
 2)