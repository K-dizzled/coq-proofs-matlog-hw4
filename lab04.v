Section lab04.

(* Write your proof terms in place of `provide_solution` *)
(* Do not use tactics! *)

Axiom provide_solution : forall {A}, A.

Section Logic.

(** Exercise: show that existential quantifier (the `ex` type) is a more general case of conjunction (the `and` type).
    This is because terms of type `ex` are dependent pairs, while terms of type `and`
    are non-dependent pairs, i.e. the type of the second component in independent of the
    value of the first one. *)

Definition and_via_ex (A B : Prop) :
  (exists (_ : A), B) <-> A /\ B
:= conj (
      fun f => 
        match 
          f 
        with 
        | ex_intro _ a b => conj a b 
        end 
    ) (
      fun (aAb : A /\ B) => (
        ex_intro _ (proj1 aAb) (proj2 aAb)
      ) 
    ).

(** Exercise: The dual Frobenius rule *)

Definition Frobenius2 :=
  forall (A : Type) (P : A -> Prop) (Q : Prop),
    (forall x, Q \/ P x) <-> (Q \/ forall x, P x).

Definition LEM_iff_Frobenius2 :
  (forall P : Prop, P \/ ~ P) <-> Frobenius2
:= provide_solution.

End Logic.

Section ExtensionalEqualityAndComposition.

Variables A B C D : Type.

Notation "f \o g" := (fun x => f (g x)) (at level 50).
Notation "f =1 g" := (forall x, f x = g x) (at level 70, no associativity).

(** [=1] stands for extensional equality on unary functions *)

(** Exercise : associativity of function composition *)
Definition compA (f : A -> B) (g : B -> C) (h : C -> D) :
  (h \o g) \o f = h \o (g \o f)
:= eq_refl (fun x => h (g (f x))).

(** Exercise: Reflexivity *)
Definition eqext_refl :
  forall (f : A -> B), f =1 f
:= fun f x => eq_refl (f x).

(** Exercise: Symmetry *)
Definition eqext_sym :
  forall (f g : A -> B), f =1 g -> g =1 f
:= fun f g => fun FxfEg => fun x => 
    match 
        (FxfEg x) in (_ = b) 
        return (b = f x) 
    with
    | eq_refl _ => eq_refl (f x)
    end.

(** Exercise: Transitivity *)
Definition eqext_trans :
  forall (f g h : A -> B), f =1 g -> g =1 h -> f =1 h
:= fun f g h => fun fEg => fun gEh => fun x => 
    match 
        (gEh x) in (_ = b) 
        return (f x = b) 
    with
    | eq_refl _ => 
        match 
            (fEg x) in (_ = b)
            return (f x = b)
        with 
            | eq_refl => eq_refl (f x)
        end
    end.

(** Exercise: left congruence *)
Definition eq_compl :
  forall (f g : A -> B) (h : B -> C),
    f =1 g -> h \o f =1 h \o g
:= fun f g => fun h => fun fEg => fun x => 
    match 
      (fEg x)
    with 
    | eq_refl => eq_refl (h (f x))
    end.

(** Exercise: right congruence *)
Definition eq_compr :
  forall (f g : B -> C) (h : A -> B),
    f =1 g -> f \o h =1 g \o h
:= fun f g => fun h => fun fEg => fun x => 
    match 
      (fEg (h x))
    with 
    | eq_refl => eq_refl (f (h x))
    end.

End ExtensionalEqualityAndComposition.
