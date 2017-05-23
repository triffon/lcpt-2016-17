(pp (py "alpha"))
(add-var-name "x" (py "alpha"))
(pp (pt "x"))

(add-pvar-name "A" (make-arity))
(add-pvar-name "B" (make-arity))
(add-pvar-name "C" (make-arity))
(pp (pf "A"))
(pp (pf "A & B"))
(pp (pf "A & B -> B & A"))

(set-goal (pf "A -> A"))
(assume "u")
(use "u")
(current-proof)

(set-goal (pf "A -> B -> A"))
(assume "u")
(assume "v")
(use "u")
(dp (current-proof))

(set-goal (pf "(A -> B -> C) -> (A -> B) -> A -> C"))
(assume "u" "v" "w")
(use "u")
(use "w")
(use "v")
(use "w")
(dp (current-proof))

(set-goal (pf "A & B -> B & A"))
(assume "u")
; ("въвеждане на конюнкция...")
(split)
(use "u")
(use "u")
(dp (current-proof))

(set-goal (pf "A ord B -> (A -> C) -> (B -> C) -> C"))
(assume "u" "v" "w")
; ("елиминация на дизюнкция...")
(elim "u")
(use "v")
(use "w")
(dp (current-proof))

(set-goal (pf "(A -> F) ord (B -> F) -> A & B -> F"))
(assume "u" "v")
(elim "u")
; доказваме (A -> F) -> F
(assume "a") ; (A -> F)
(use "a")
(use "v")
; доказваме (B -> F) -> F
(assume "b") ; (B -> F)
(use "b")
(use "v")
(dp (current-proof))

(add-pvar-name "p" (make-arity (py "alpha")))
(pp (pf "p(x)"))

(set-goal (pf "ex x (p(x) -> F) -> all x p(x) -> F"))
(assume "u" "v")
(ex-elim "u")
(assume "x" "w")
(use "w")
(use "v")
(dp (current-proof))
