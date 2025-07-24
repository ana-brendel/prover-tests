Set Warnings "-notation-overridden,-parsing,-deprecated-hint-without-locality".
From Coq Require Export Lists.List.
From Coq Require Export Bool.Bool.
From Coq Require Export Arith.Arith.
From Coq Require Export Arith.EqNat.
From Coq Require Export Permutation.
Export ListNotations.
Require Export Lia.

Inductive sorted: list nat -> Prop :=
 | sorted_nil: sorted []
 | sorted_1: forall i, sorted [i]
 | sorted_cons: forall i j l, i <= j -> sorted (j :: l) -> sorted (i :: j :: l).

Definition is_a_sorting_algorithm (f: list nat -> list nat) := forall al,
    Permutation al (f al) /\ sorted (f al).

Fixpoint select (x: nat) (l: list nat) : nat * list nat :=
  match l with
  | [] => (x, [])
  | h :: t =>
    if x <=? h
    then let (j, l') := select x t
         in (j, h :: l')
    else let (j, l') := select h t
         in (j, x :: l')
  end.

Fixpoint selsort (l : list nat) (n : nat) : list nat :=
  match l, n with
  | _, O => []  (* ran out of fuel *)
  | [], _ => []
  | x :: r, S n' => let (y, r') := select x r
                  in y :: selsort r' n'
end.

Definition selection_sort (l : list nat) : list nat := selsort l (length l).

Definition le_all x xs := Forall (fun y => x <= y) xs.
Infix "<=*" := le_all (at level 70, no associativity).

(* ################################################################# *)

Lemma le_all__le_one : forall lst y n, y <=* lst -> In n lst -> y <= n.
Proof. 
    intros. unfold le_all in H. destruct H.
    - contradiction.
    - inversion H0. 
    -- lia.
    -- eapply Forall_forall. eassumption. eassumption.
Qed.

Lemma cons_of_small_maintains_sort: forall bl y n,
  n = length bl -> y <=* bl -> sorted (selsort bl n) -> sorted (y :: selsort bl n).
Proof.
    intros. induction (selsort bl n) eqn:K.
    - apply sorted_1.
    - apply sorted_cons.
    --  eapply le_all__le_one. eauto. 
    Admitted.