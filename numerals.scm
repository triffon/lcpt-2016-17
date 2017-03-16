; (<Функция> <аргумент1> <аргумент2> ... <аргументn>)

; (define <име> <израз>) 

; (lambda (x) <тяло>)

; (lambda (f x) ...) != (lambda (f) (lambda (x) ...))

(define c1
  (lambda (f)
    (lambda (x) (f x))))

(define c0
  (lambda (f)
    (lambda (x) x)))

(define c5
  (lambda (f)
    (lambda (x)
      (f (f (f (f (f x))))))))

(define (cn n)
  (lambda (f)
    (lambda (x)
      (repeated n f x))))

(define (repeated n f x)
  (if (= n 0) x
      (f (repeated (- n 1) f x))))

(define 1+ (lambda (x) (+ x 1)))

(define (printn c)
  ((c 1+) 0))

(define cs
  (lambda (n)
    (lambda (f)
      (lambda (x)
        (f ((n f) x))))))

(define c+
  (lambda (m)
    (lambda (n)
      (lambda (f)
        (lambda (x)
          ((m f) ((n f) x)))))))

(define c++
  (lambda (m)
    (lambda (n)
      ((m cs) n))))

(define c*
  (lambda (m)
    (lambda (n)
      (lambda (f)
        (m (n f))))))

(define c**
  (lambda (m)
    (lambda (n)
      ((m (c+ n)) c0))))

(define c^^
  (lambda (m)
    (lambda (n)
      ((n (c* m)) c1))))

(define c^
  (lambda (m)
    (lambda (n)
      (n m))))

(define c^'
  (lambda (m)
    (lambda (n)
      (m n))))

(define I (lambda (x) x))
(define K (lambda (x) (lambda (y) x)))
(define K* (lambda (x) (lambda (y) y)))
(define S (lambda (x)
            (lambda (y)
              (lambda (z)
                ((x z) (y z))))))

(define c#t K)
(define c#f K*)

(define cif
  (lambda (b)
    (lambda (x)
      (lambda (y)
        ((b x) y)))))

(define c!
  (lambda (p)
    (lambda (x)
      (lambda (y)
        ((p y) x)))))

(define c!!
  (lambda (p)
    ((p c#f) c#t)))

(define c&
  (lambda (p)
    (lambda (q)
      ((p q) c#f))))

(define cv
  (lambda (p)
    (p c#t)))
  
(define printb
  (lambda (b) ((b #t) #f)))

(define c=0
  (lambda (n)
    ((n (lambda (x) c#f)) c#t)))

(define c/2
  (lambda (n)
    ((n c!) c#t)))

(define ccons
  (lambda (x)
    (lambda (y)
      (lambda (s)
        ((s x) y)))))

(define ccar (lambda (p) (p K)))
(define ccdr (lambda (p) (p K*)))

(define printpair
  (lambda (print)
    (lambda (p)
      (cons (print (ccar p)) (print (ccdr p))))))

(define printbpair (printpair printb))
(define printnpair (printpair printn))
