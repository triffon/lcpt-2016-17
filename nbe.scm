                                        ; (lambda (x) (x y))
                                        ; '(arrow rho sigma) 'alpha

(define (cons-app f x) (list f x))      ; (f x)
                                        ; (define cons-app list)
(define (cons-abs x m) (list 'lambda (list x) m))
                                        ; (lambda (x) m)

(define (is-app? M) (and (list? M) (= (length M) 2)))
(define (is-abs? M) (and (list? M) (eq? (car M) 'lambda) (= (length M) 3)
                         (list? (cadr M)) (= (length (cadr M)) 1)))
(define is-var? symbol?)

(define (atom? x) (not (pair? x)))

(define (reify tau M)
  (if (atom? tau) M
      (let ((rho   (cadr tau))
            (sigma (caddr tau)))
        (lambda (a)
          (reify sigma (cons-app M (reflect rho a)))))))

(define (reflect tau f)
  (if (atom? tau) f
      (let ((rho (cadr tau))
            (sigma (caddr tau))
            (x (gensym 'x))) ; Генерира свежа променлива
        (cons-abs x (reflect sigma (f (reify rho x)))))))

; xi : V -> Л
(define (modify xi var a)
  (lambda (x)
    (if (eq? x var) a
        (xi x))))

(define (eval M xi)    ; [[M]]_xi
  (cond ((is-var? M) (xi M))
        ((is-app? M)
         (let ((func (car M))
               (arg  (cadr M)))
           ((eval func xi)
            (eval arg xi))))
        ((is-abs? M)
         (let ((var  (caadr M))
               (body (caddr M)))
           (lambda (a)
             (eval body (modify xi var a)))))))

                                        ; работи само над затворени термове
                                        ; ако изпълним над отворен терм, тогава нормалната форма няма да е дълга
(define (nbe M tau)
  (reflect tau (eval M (lambda (x) x))))

(define tn '(arrow (arrow alpha alpha) (arrow alpha alpha)))

(define (repeated n f x)
  (if (= n 0) x
      (cons-app f (repeated (- n 1) f x))))

(define (c n)
  (cons-abs 'f (cons-abs 'x (repeated n 'f 'x))))

(define c+
  '(lambda (m)
     (lambda (n)
       (lambda (f)
         (lambda (x)
           ((m f) ((n f) x)))))))

(define c8 (cons-app (cons-app c+ (c 3)) (c 5)))

(define c*
  '(lambda (m)
     (lambda (n)
       (lambda (f)
         (m (n f))))))
