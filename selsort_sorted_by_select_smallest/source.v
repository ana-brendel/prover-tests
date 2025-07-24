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

Lemma select_perm: forall x l y r, select x l = (y, r) -> Permutation (x :: l) (y :: r).
Proof. 
    intros x l; revert x.
    induction l.
    - simpl. intros. inversion H. auto.
    - simpl. intros. destruct (x <=? a).
    -- destruct (select x l) eqn:Q. inversion H.
    apply perm_trans with (a :: y :: l0).
    apply perm_trans with (a :: x :: l).
    apply perm_swap.
    apply perm_skip. apply IHl. rewrite <- H1. assumption.
    apply perm_swap.
    -- specialize (IHl a). destruct (select a l) eqn:Q. 
    inversion H.
    apply perm_trans with (x :: y :: l0).
    apply perm_skip. apply IHl. rewrite H1. reflexivity.
    apply perm_swap.
Qed.

Lemma select_rest_length : forall x l y r, select x l = (y, r) -> length l = length r.
Proof.
    intros x l; revert x. induction l.
    - intros. inversion H. reflexivity.
    - intros. inversion H. destruct (x <=? a).
    + destruct (select x l) eqn:Q. inversion H1. simpl. f_equal. eapply IHl. eauto.
    + destruct (select a l) eqn:Q. inversion H1. simpl. f_equal. eapply IHl. eauto.
Qed.

Lemma eqb_reflect : forall x y, reflect (x = y) (x =? y).
Proof.
  intros x y. apply iff_reflect. symmetry.
  apply Nat.eqb_eq.
Qed.

Lemma ltb_reflect : forall x y, reflect (x < y) (x <? y).
Proof.
  intros x y. apply iff_reflect. symmetry.
  apply Nat.ltb_lt.
Qed.

Lemma leb_reflect : forall x y, reflect (x <= y) (x <=? y).
Proof.
  intros x y. apply iff_reflect. symmetry.
  apply Nat.leb_le.
Qed.

Hint Resolve ltb_reflect leb_reflect eqb_reflect : bdestruct.

Ltac bdestruct X :=
  let H := fresh in let e := fresh "e" in
   evar (e: Prop);
   assert (H: reflect e X); subst e;
    [eauto with bdestruct
    | destruct H as [H|H];
       [ | try first [apply not_lt in H | apply not_le in H]]].


Lemma select_fst_leq: forall al bl x y, select x al = (y, bl) -> y <= x.
Proof. 
    induction al.
    - intros. inversion H. reflexivity.
    - intros. inversion H. bdestruct (x <=? a).
    -- destruct (select x al) eqn:Q. 
    eapply IHal. rewrite Q. 
    inversion H1. exists.
    -- destruct (select a al) eqn:Q. 
    apply IHal in Q. inversion H1. lia.
Qed.

Lemma le_all__le_one : forall lst y n, y <=* lst -> In n lst -> y <= n.
Proof. 
    intros. unfold le_all in H. destruct H.
    - contradiction.
    - inversion H0. 
    -- lia.
    -- eapply Forall_forall. eassumption. eassumption.
Qed.

Lemma select_smallest: forall al bl x y, select x al = (y, bl) -> y <=* bl.
Proof. 
    intros al. induction al.
    - intros. inversion H. unfold le_all. apply Forall_nil.
    - intros. unfold select in H. bdestruct (x <=? a).
    -- fold select in H. destruct (select x al) eqn:Q. inversion Q. apply IHal in Q.
    apply select_fst_leq in H2. inversion H. rewrite <- H3. apply Forall_cons. lia. assumption.
    -- fold select in H. destruct (select a al) eqn:Q. inversion Q. apply IHal in Q.
    apply select_fst_leq in H2. inversion H. rewrite <- H3. apply Forall_cons. lia. assumption.
Qed.
   
Lemma select_in : forall al bl x y, select x al = (y, bl) -> In y (x :: al).
Proof.
    intros.
    apply select_perm in H.
    eapply Permutation_in.
    symmetry in H.
    eassumption.
    simpl. left. reflexivity.
Qed.

Lemma cons_of_small_maintains_sort: forall bl y n,
  n = length bl -> y <=* bl -> sorted (selsort bl n) -> sorted (y :: selsort bl n).
Proof.
    intros bl y n. revert bl; revert y. induction n.
    - intros. destruct bl. apply sorted_1. simpl in H. lia.
    - intros. simpl. destruct bl.
    -- apply sorted_1.
    -- simpl in H. inversion H. destruct (select n0 bl) eqn:Q. inversion Q.
    apply select_in in Q. 
    apply sorted_cons. 
    eapply le_all__le_one. eassumption. eassumption.
    rewrite <- H3. apply IHn.
    --- rewrite H3. eapply select_rest_length. eassumption.
    --- eapply select_smallest. eassumption.
    --- simpl in H1. rewrite H4 in H1. inversion H1. apply sorted_nil. assumption.
Qed.

Lemma selsort_sorted : forall n al, length al = n -> sorted (selsort al n).
Proof. 
    intros n. induction n.
    - intros. simpl. destruct al. apply sorted_nil. apply sorted_nil.
    - intros. destruct al.
    -- simpl in H. lia.
    -- simpl. destruct (select n0 al) eqn:Q. apply cons_of_small_maintains_sort.
    --- simpl in H. apply select_rest_length in Q. rewrite <- Q. lia.
    --- Admitted.
