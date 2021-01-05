#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

(define (string-append-map xs suffix)
  (map (lambda (ostring)
         (string-append ostring suffix))
       xs))

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (car (list-tail xs (remainder n (length xs))))]))

(define (stream-for-n-steps s n)
  (if (< n 1)
      null
      (let ([pair (s)])
        (cons (car pair) (stream-for-n-steps (cdr pair) (- n 1))))))

(define (funny-number-stream)
  (letrec ([f (lambda (x) (cons (if (= 0 (remainder x 5))
                                    (* x -1)
                                    x)
                                (lambda () (f (+ x 1)))))])
    (f 1)))

(define (dan-then-dog)
  (letrec ([f (lambda (cur) (cons cur (if (string=? cur "dan.jpg")
                                          (lambda () (f "dog.jpg"))
                                          (lambda () (f "dan.jpg")))))])
    (f "dan.jpg")))

(define (stream-add-zero s)
  (let ([evaluated (s)])
    (lambda () (cons (cons 0 (car evaluated))
                     (stream-add-zero (cdr evaluated))))))

(define (cycle-lists xs ys)
  (letrec ([f (lambda (x y)
              (let ([x (if (null? x) xs x)]
                    [y (if (null? y) ys y)])
                (cons (cons (car x) (car y)) (lambda () (f (cdr x) (cdr y))))))])
    (lambda () (f xs ys))))

(define (vector-assoc v vec)
  (letrec ([f (lambda (pos)
                (cond [(>= pos (vector-length vec)) #f]
                      [(not (pair? (vector-ref vec pos))) (f (+ pos 1))]
                      [(equal? v (car (vector-ref vec pos))) (vector-ref vec pos)]
                      [#t (f (+ pos 1))]))])
    (f 0)))

(define (cached-assoc xs n)
  (let* ([cache (make-vector n)]
         [cache-pos 0]
         [add-to-cache (lambda (v) (begin (if (>= cache-pos n) (set! cache-pos 0) 0)
                                          (vector-set! cache cache-pos v)
                                          (set! cache-pos (+ cache-pos 1))))])
    (lambda (v) (let ([possibly-saved (vector-assoc v cache)])
                  (cond [possibly-saved possibly-saved]
                        [#t (let ([returned-value (assoc v xs)])
                              (begin (add-to-cache returned-value)
                                     returned-value))])))))

(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([res-e1 e1]
           [f (lambda () (if (< e2 res-e1)
                             (f)
                             #t))])
       (f))]))                            

                                