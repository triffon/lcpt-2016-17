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

(define (nbe M tau)
  (reflect tau (eval M (lambda (x) x))))

