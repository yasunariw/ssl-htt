From mathcomp
Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From fcsl
Require Import prelude pred pcm unionmap heap.
From HTT
Require Import stmod stsep stlog stlogR.
From SSL
Require Import core.

Inductive lseg (x : ptr) (s : seq nat) (h : heap) : Prop :=
| lseg_1 of x == null of
  @perm_eq nat_eqType (s) (nil) /\ h = empty
| lseg_2 of (x == null) = false of
  exists (v : nat) (s1 : seq nat) (nxt : ptr),
  exists h_lseg_nxts1_513,
  @perm_eq nat_eqType (s) ([:: v] ++ s1) /\ h = x :-> v \+ x .+ 1 :-> nxt \+ h_lseg_nxts1_513 /\ lseg nxt s1 h_lseg_nxts1_513.

Inductive lseg2 (x : ptr) (y : ptr) (s : seq nat) (h : heap) : Prop :=
| lseg2_1 of x == y of
  @perm_eq nat_eqType (s) (nil) /\ h = empty
| lseg2_2 of (x == y) = false of
  exists (v : nat) (s1 : seq nat) (nxt : ptr),
  exists h_lseg2_nxtys1_514,
  @perm_eq nat_eqType (s) ([:: v] ++ s1) /\ h = x :-> v \+ x .+ 1 :-> nxt \+ h_lseg2_nxtys1_514 /\ lseg2 nxt y s1 h_lseg2_nxtys1_514.

Lemma lseg_perm_eq_trans4 x h s_1 s_2 : perm_eq s_1 s_2 -> lseg x s_1 h -> lseg x s_2 h. Admitted.
Hint Resolve lseg_perm_eq_trans4: ssl_pred.
Lemma lseg2_perm_eq_trans5 x y h s_1 s_2 : perm_eq s_1 s_2 -> lseg2 x y s_1 h -> lseg2 x y s_2 h. Admitted.
Hint Resolve lseg2_perm_eq_trans5: ssl_pred.

Definition listfree_type :=
  forall (vprogs : ptr),
  {(vghosts : seq nat)},
  STsep (
    fun h =>
      let: (x) := vprogs in
      let: (s) := vghosts in
      exists h_lseg_xs_515,
      h = h_lseg_xs_515 /\ lseg x s h_lseg_xs_515,
    [vfun (_: unit) h =>
      let: (x) := vprogs in
      let: (s) := vghosts in
      h = empty
    ]).

Program Definition listfree : listfree_type :=
  Fix (fun (listfree : listfree_type) vprogs =>
    let: (x) := vprogs in
    Do (
      if x == null
      then
        ret tt
      else
        nxtx2 <-- @read ptr (x .+ 1);
        listfree (nxtx2);;
        dealloc x;;
        dealloc (x .+ 1);;
        ret tt
    )).
Obligation Tactic := intro; move=>x; ssl_program_simpl.
Next Obligation.
ssl_ghostelim_pre.
move=>s.
ex_elim h_lseg_xs_515.
move=>[sigma_self].
subst h_self.
move=>H_lseg_xs_515.
ssl_ghostelim_post.
ssl_open (x == null);
ssl_open_post H_lseg_xs_515.
move=>[phi_lseg_xs_5150].
move=>[sigma_lseg_xs_515].
subst h_lseg_xs_515.
ssl_emp;
sslauto.
ex_elim vx2 s1x nxtx2.
ex_elim h_lseg_nxtx2s1x_513x.
move=>[phi_lseg_xs_5150].
move=>[sigma_lseg_xs_515].
subst h_lseg_xs_515.
move=>H_lseg_nxtx2s1x_513x.
ssl_read (x .+ 1).
ssl_call_pre (h_lseg_nxtx2s1x_513x).
ssl_call (s1x).
exists (h_lseg_nxtx2s1x_513x);
sslauto.
move=>h_call1.
move=>[sigma_call1].
subst h_call1.
store_valid.
ssl_dealloc x.
ssl_dealloc (x .+ 1).
ssl_emp;
sslauto.
Qed.
