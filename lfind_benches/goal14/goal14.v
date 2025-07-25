Require Import Nat Arith.

Inductive Nat : Type := succ : Nat -> Nat |  zero : Nat.

Inductive Lst : Type := cons : Nat -> Lst -> Lst |  nil : Lst.

Fixpoint less (less_arg0 : Nat) (less_arg1 : Nat) : bool
           := match less_arg0, less_arg1 with
              | _, zero => false
              | zero, succ x => true
              | succ x, succ y => less x y
              end.

Fixpoint eqn (m n : Nat) : bool :=
  match m , n with
  | zero , zero => true
  | succ m' , succ n' => eqn m' n'
  | _, _ => false
  end.

Definition leq (m n : Nat) : bool :=
  orb (eqn m n) (less m n).

Fixpoint insort (insort_arg0 : Nat) (insort_arg1 : Lst) : Lst
           := match insort_arg0, insort_arg1 with
              | i, nil => cons i nil
              | i, cons x y => if less i x then cons i (cons x y) else cons x (insort i y)
              end.

Fixpoint sorted (sorted_arg0 : Lst) : bool
           := match sorted_arg0 with
              | nil => true
              | cons x l =>
                let s := sorted l in
                match l with
                | nil => true
                | cons y _ => andb s (leq x y)
                end
              end.

Fixpoint sort (sort_arg0 : Lst) : Lst
           := match sort_arg0 with
              | nil => nil
              | cons x y => insort x (sort y)
              end.

(* Lemma lem: forall n l, sorted l = true -> sorted (insort n l) = true. *)

Theorem goal14 (n: Nat) (x: Lst) (IHx: sorted (sort x) = true) : sorted (insort n (sort x)) = true.
Proof. Admitted.
