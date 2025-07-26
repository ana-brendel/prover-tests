Require Import Nat Arith Bool.

Inductive Nat : Type := zero : Nat | succ : Nat -> Nat.

Scheme Equality for Nat.

Inductive Lst : Type := nil : Lst | cons : Nat -> Lst -> Lst.

Fixpoint mem (mem_arg0 : Nat) (mem_arg1 : Lst) : bool
           := match mem_arg0, mem_arg1 with
              | _, nil => false
              | x, cons y z => orb (Nat_beq x y) (mem x z)
              end.

Definition lst_mem := mem.

Fixpoint lst_intersection (lst_intersection_arg0 : Lst) (lst_intersection_arg1 : Lst) : Lst
           := match lst_intersection_arg0, lst_intersection_arg1 with
              | nil, x => nil
              | cons n x, y => if lst_mem n y then cons n (lst_intersection x y) else lst_intersection x y
              end.

Theorem goal44 
(x n: Nat)
(y z: Lst)
(H: Nat_beq x n = true)
(H0: lst_mem x z = true)
(IHy: lst_mem x y = true -> lst_mem x (lst_intersection y z) = true)
(Heqb: lst_mem n z = false)
: lst_mem x (lst_intersection y z) = true.
Proof. Admitted.