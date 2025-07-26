Require Import Nat Arith Bool.

Inductive Nat : Type := zero : Nat | succ : Nat -> Nat.

Scheme Equality for Nat.

Inductive Lst : Type := nil : Lst | cons : Nat -> Lst -> Lst.

Fixpoint less (less_arg0 : Nat) (less_arg1 : Nat) : bool
           := match less_arg0, less_arg1 with
              | _, zero => false
              | zero, succ x => true
              | succ x, succ y => less x y
              end.

Definition leq (x : Nat) (y : Nat) : bool :=
  Nat_beq x y || less x y.

Fixpoint insort (insort_arg0 : Nat) (insort_arg1 : Lst) : Lst
           := match insort_arg0, insort_arg1 with
              | i, nil => cons i nil
              | i, cons x y => if less i x then cons i (cons x y) else cons x (insort i y)
              end.

Fixpoint sorted (sorted_arg0 : Lst) : bool
           := match sorted_arg0 with
              | nil => true
              | cons x l => match l with
                | nil => true
                | cons z y => andb (sorted l) (leq x z)
                end
              end.

Fixpoint sort (sort_arg0 : Lst) : Lst
           := match sort_arg0 with
              | nil => nil
              | cons x y => insort x (sort y)
              end.
              
Theorem goal62_2 
(n n0: Nat)
(x: Lst)
(y: Nat)
(H:
  match x with
  | nil => true
  | cons z _ => sorted x && leq n0 z
  end = true)
(H0: leq n n0 = true)
(Heqb0: less y n0 = true)
(IHx:
  match x with
  | nil => true
  | cons z _ => sorted x && leq n0 z
  end = true -> sorted (cons y (cons n0 x)) = true)
(Heqb: less y n = false)
:  andb true (andb (leq y n0) (leq n y)) = true.
Proof. Admitted.
