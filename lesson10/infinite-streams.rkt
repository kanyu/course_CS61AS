; SICP compatible for stream

#lang racket
(require "../misc.scm")
(require "streams.scm")

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y)
  (= (remainder x y) 0))
(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))

(define (add-streams s1 s2)
  (stream-map + s1 s2))
