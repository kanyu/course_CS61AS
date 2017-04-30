#lang racket

(define (memo-proc proc)
  (let ((already-run? false)
		(result false))
	(define promise
	  (lambda ()
		(if (not already-run?)
			(begin (set! result (proc))
				   (set! already-run? true)
				   result)
			result)))
	promise))

#|
;; non-memozing stream
(define-syntax cons-stream
  (syntax-rules ()
	((_ a b) (cons a (lambda () b)))))
|#

;; memoizing stream
(define-syntax cons-stream
  (syntax-rules ()
	((_ a b) (cons a (memo-proc (lambda () b))))))

(define (stream-car s) (car s))
(define (stream-cdr s) ((cdr s)))
(define (stream-null? s) (null? s))
(define the-empty-stream '())

(define (stream-ref s n)
  (if (= n 0)
	  (stream-car s)
	  (stream-ref (stream-cdr s) (- n 1))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
		((pred (stream-car stream))
		 (cons-stream (stream-car stream)
					  (stream-filter pred
									 (stream-cdr stream))))
		(else (stream-filter pred (stream-cdr stream)))))

(define (stream-enumerate-interval low high)
  (if (> low high)
	  the-empty-stream
	  (cons-stream
	   low
	   (stream-enumerate-interval (+ low 1) high))))

(define (stream-for-each proc s)
  (if (stream-null? s)
	  'done
	  (begin (proc (stream-car s))
			 (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each
   (lambda (x) (display (format "~a " x))) s)
  (newline))

;; from ex 3.50
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
	  the-empty-stream
	  (cons-stream
	   (apply proc (map stream-car argstreams))
	   (apply stream-map
			  (cons proc (map stream-cdr argstreams))))))

(define (list->stream sequence)
  (if (null? sequence)
	  the-empty-stream
	  (cons-stream (car sequence)
				   (list->stream (cdr sequence)))))

(define (stream->list s)
  (if (stream-null? s)
	  the-empty-stream
	  (cons (stream-car s)
			(stream->list (stream-cdr s)))))

(define (scale-stream s factor)
  (stream-map (lambda (x) (* x factor)) s))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(define (stream-append s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (stream-append (stream-cdr s1) s2))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(provide (all-defined-out))
