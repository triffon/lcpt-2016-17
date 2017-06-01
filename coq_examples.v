Section Test.
Check 0.
Check nat.
Check Set.
Check Type.
Variable n : nat.
Hypothesis Pos_n : n > 0.
Check n.
Check Pos_n.
Check gt n 0.
Check gt.
Check Prop.
End Test.

Section Test2.
Definition one := (S 0).
Check one.
Definition three := (S (S one)).
Definition double (m:nat) := plus m m.
Check double.
Print double.
Print gt.
Check forall m:nat, gt m 0.
End Test2.

Section MinLog.
Variables A B C : Prop.
Check (A -> B).

Goal (A -> A).
intro H.
apply H.
Save Identity.
Print Identity.

Lemma K : (A -> B -> A).
intros H1 H2.
exact H1.
Qed.

Theorem S : (A -> B -> C) -> (A -> B) -> A -> C.
intros.
apply H; [ assumption | apply H0; assumption ].
Qed.

Lemma commutativity : A /\ B -> B /\ A.
intro.
elim H.
split.
assumption.
assumption.
Qed.

Lemma commutativity2 : A /\ B -> B /\ A.
tauto.
Qed.
Print commutativity2.

Lemma Peirce : (((A -> B) -> A) -> A).
try tauto.
Abort.

Hypothesis Stab : (~~A -> A).

Lemma NNPeirce : ~~(((A -> B) -> A) -> A).
intro H.
apply H.
intro H1.
apply H1.
intro H2.
exfalso.
apply H.
intros.
assumption.
Qed.
End MinLog.

Section PredLog.
Variable D : Set.
Variable R : D -> D -> Prop.
Hypothesis R_sym : forall x y:D, R x y -> R y x.
Hypothesis R_trans : forall x y z:D, R x y -> 
   R y z -> R x z.

Lemma refl_if : forall x:D, (exists y, R x y)
                  -> R x x.
intro x.
intro x_result.
elim x_result.
intros y Rxy.
apply R_trans with y.
assumption.
apply R_sym ; assumption.
Qed.
End PredLog.