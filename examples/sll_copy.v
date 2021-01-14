From mathcomp
Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From fcsl
Require Import prelude pred pcm unionmap heap.
From HTT
Require Import stmod stsep stlog stlogR.
From SSL
Require Import core.

Inductive sll (x : ptr) (s : seq nat) (h : heap) : Prop :=
| sll1 of x == null of
  @perm_eq nat_eqType (s) (nil) /\ h = empty
| sll2 of ~~ (x == null) of
  exists (v : nat) (s1 : seq nat) (nxt : ptr),
  exists h_sll_nxts1_534,
  @perm_eq nat_eqType (s) ([:: v] ++ s1) /\ h = x :-> v \+ x .+ 1 :-> nxt \+ h_sll_nxts1_534 /\ sll nxt s1 h_sll_nxts1_534.

Definition sll_copy_type :=
  forall (vprogs : ptr),
  {(vghosts : ptr * seq nat)},
  STsep (
    fun h =>
      let: (r) := vprogs in
      let: (x, s) := vghosts in
      exists h_sll_xs_a,
      h = r :-> x \+ h_sll_xs_a /\ sll x s h_sll_xs_a,
    [vfun (_: unit) h =>
      let: (r) := vprogs in
      let: (x, s) := vghosts in
      exists y,
      exists h_sll_xs_a h_sll_ys_b,
      h = r :-> y \+ h_sll_xs_a \+ h_sll_ys_b /\ sll x s h_sll_xs_a /\ sll y s h_sll_ys_b
    ]).
Program Definition sll_copy : sll_copy_type :=
  Fix (fun (sll_copy : sll_copy_type) vprogs =>
    let: (r) := vprogs in
    Do (
      x2 <-- @read ptr r;
      if x2 == null
      then
        ret tt
      else
        vx22 <-- @read nat x2;
        nxtx22 <-- @read ptr (x2 .+ 1);
        r ::= nxtx22;;
        sll_copy (r);;
        y12 <-- @read ptr r;
        y2 <-- allocb null 2;
        r ::= y2;;
        (y2 .+ 1) ::= y12;;
        y2 ::= vx22;;
        ret tt
    )).
Obligation Tactic := intro; move=>r; ssl_program_simpl.
Next Obligation.
Hypothesis sll_perm_eq_trans19: forall x h s_1 s_2, perm_eq s_1 s_2 -> sll x s_1 h -> sll x s_2 h.
Hint Resolve sll_perm_eq_trans19: ssl_pred.
ssl_ghostelim_pre.
move=>[x2 s].
ex_elim h_sll_x2s_a.
move=>[sigma_self].
subst.
move=>H_sll_x2s_a.
ssl_ghostelim_post.
ssl_read r.
ssl_open.
ssl_open_post H_sll_x2s_a.
move=>[phi_sll_x2s_a0].
move=>[sigma_sll_x2s_a].
subst.
Hypothesis pure20 : @perm_eq nat_eqType (nil) (nil).
Hint Resolve pure20: ssl_pure.
ssl_emp;
exists (null);
exists (empty);
exists (empty);
sslauto.
unfold_constructor 1;
sslauto.
unfold_constructor 1;
sslauto.
ssl_open_post H_sll_x2s_a.
ex_elim vx22 s1x2 nxtx22.
ex_elim h_sll_nxtx22s1x2_534x2.
move=>[phi_sll_x2s_a0].
move=>[sigma_sll_x2s_a].
subst.
move=>H_sll_nxtx22s1x2_534x2.
ssl_read x2.
ssl_read (x2 .+ 1).
ssl_write r.
ssl_call_pre (r :-> nxtx22 \+ h_sll_nxtx22s1x2_534x2).
ssl_call (nxtx22, s1x2).
exists (h_sll_nxtx22s1x2_534x2);
sslauto.
move=>h_call1.
ex_elim y12.
ex_elim h_sll_nxtx22s1x2_534x2 h_sll_y12s1x2_b1.
move=>[sigma_call1].
subst.
move=>[H_sll_nxtx22s1x2_534x2 H_sll_y12s1x2_b1].
store_valid.
ssl_read r.
ssl_alloc y2.
Hypothesis pure21 : forall b1, b1 < b1 + 1.
Hint Resolve pure21: ssl_pure.
ssl_write r.
ssl_write_post r.
ssl_write (y2 .+ 1).
ssl_write_post (y2 .+ 1).
Hypothesis pure22 : forall vx22 s1x2, @perm_eq nat_eqType ([:: vx22] ++ s1x2) ([:: vx22] ++ s1x2).
Hint Resolve pure22: ssl_pure.
Hypothesis pure23 : forall vx22 s1x2, @perm_eq nat_eqType ([:: vx22] ++ s1x2) ([:: vx22] ++ s1x2).
Hint Resolve pure23: ssl_pure.
ssl_write y2.
ssl_write_post y2.
ssl_emp;
exists (y2);
exists (x2 :-> vx22 \+ x2 .+ 1 :-> nxtx22 \+ h_sll_nxtx22s1x2_534x2);
exists (y2 :-> vx22 \+ y2 .+ 1 :-> y12 \+ h_sll_y12s1x2_b1);
sslauto.
unfold_constructor 2;
exists (vx22), (s1x2), (nxtx22);
exists (h_sll_nxtx22s1x2_534x2);
sslauto.
unfold_constructor 2;
exists (vx22), (s1x2), (y12);
exists (h_sll_y12s1x2_b1);
sslauto.
Qed.
