Require Import Nat Arith Bool.

Inductive Nat : Type := zero : Nat | succ : Nat -> Nat.

Scheme Equality for Nat.

Inductive Lst : Type := nil : Lst | cons : Nat -> Lst -> Lst.

Fixpoint append (append_arg0 : Lst) (append_arg1 : Lst) : Lst
           := match append_arg0, append_arg1 with
              | nil, x => x
              | cons x y, z => cons x (append y z)
              end.

Fixpoint mem (mem_arg0 : Nat) (mem_arg1 : Lst) : bool
:= match mem_arg0, mem_arg1 with
    | _, nil => false
    | x, cons y z => orb (Nat_beq x y) (mem x z)
    end.

Definition lst_mem (lst_mem_arg0 : Nat) (lst_mem_arg1 : Lst) : bool
           := match lst_mem_arg0, lst_mem_arg1 with
              | n, x => mem n x
              end.

Fixpoint lst_subset (lst_subset_arg0 : Lst) (lst_subset_arg1 : Lst) : Prop
           := match lst_subset_arg0, lst_subset_arg1 with
              | nil, x => True
              | cons n x, y => and (lst_subset x y) (lst_mem n y = true)
              end.

Definition lst_eq (lst_eq_arg0 : Lst) (lst_eq_arg1 : Lst) : Prop
           := match lst_eq_arg0, lst_eq_arg1 with
              | x, y => and (lst_subset x y) (lst_subset y x)
              end.

Fixpoint lst_intersection (lst_intersection_arg0 : Lst) (lst_intersection_arg1 : Lst) : Lst
           := match lst_intersection_arg0, lst_intersection_arg1 with
              | nil, x => nil
              | cons n x, y => if lst_mem n y then cons n (lst_intersection x y) else lst_intersection x y
              end.

(* Lemma mem_append : forall (n : Nat) (x y : Lst), lst_mem n x = true -> lst_mem n (append y x) = true. *)

Lemma goal41_1 (n: Nat) (x y z: Lst) (H: lst_subset x (append z y))
  (H0: lst_mem n y = true) (IHx: lst_subset x y -> lst_subset x (append z y))
  : lst_mem n (append z y) = true. Proof. Admitted.

