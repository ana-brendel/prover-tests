Require Import Nat Arith.

Inductive Nat : Type := succ : Nat -> Nat |  zero : Nat.

Inductive Lst : Type := cons : Nat -> Lst -> Lst |  nil : Lst.

Fixpoint less (less_arg0 : Nat) (less_arg1 : Nat) : bool
           := match less_arg0, less_arg1 with
              | _, zero => false
              | zero, succ x => true
              | succ x, succ y => less x y
              end.

Fixpoint eqb (n m: Nat) : bool :=
  match n, m with
    | zero, zero => true
    | zero, succ _ => false
    | succ _, zero => false
    | succ n', succ m' => eqb n' m'
  end.

Fixpoint count (count_arg0 : Nat) (count_arg1 : Lst) : Nat
           := match count_arg0, count_arg1 with
              | x, nil => zero
              | x, cons y z => if eqb x y then succ (count x z) else count x z
              end.

Fixpoint insort (insort_arg0 : Nat) (insort_arg1 : Lst) : Lst
           := match insort_arg0, insort_arg1 with
              | i, nil => cons i nil
              | i, cons x y => if less i x then cons i (cons x y) else cons x (insort i y)
              end.

Fixpoint sort (sort_arg0 : Lst) : Lst
           := match sort_arg0 with
              | nil => nil
              | cons x y => insort x (sort y)
              end.

Theorem goal50_1
(x y n: Nat)
(l: Lst)
(H: x <> y)
(IHl: count x (insort y l) = count x l)
(El: less y n = true)
(Ee: eqb x n = false)
: count x (cons y (cons n l)) = count x l.
Proof. Admitted.