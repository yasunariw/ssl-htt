From mathcomp
Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From fcsl
Require Import prelude pred pcm unionmap heap.
From HTT
Require Import stmod stsep stlog stlogR.
From SSL
Require Import core.

Inductive bst (x : ptr) (sz : nat) (lo : nat) (hi : nat) (h : heap) : Prop :=
| bst_1 of x == null of
  hi == 0 /\ lo == 7 /\ sz == 0 /\ h = empty
| bst_2 of (x == null) = false of
  exists (sz1 : nat) (sz2 : nat) (v : nat) (hi2 : nat) (hi1 : nat) (lo1 : nat) (lo2 : nat) (l : ptr) (r : ptr),
  exists h_bst_lsz1lo1hi1_525 h_bst_rsz2lo2hi2_526,
  0 <= sz1 /\ 0 <= sz2 /\ 0 <= v /\ hi == (if hi2 <= v then v else hi2) /\ hi1 <= v /\ lo == (if v <= lo1 then v else lo1) /\ sz == 1 + sz1 + sz2 /\ v <= 7 /\ v <= lo2 /\ h = x :-> v \+ x .+ 1 :-> l \+ x .+ 2 :-> r \+ h_bst_lsz1lo1hi1_525 \+ h_bst_rsz2lo2hi2_526 /\ bst l sz1 lo1 hi1 h_bst_lsz1lo1hi1_525 /\ bst r sz2 lo2 hi2 h_bst_rsz2lo2hi2_526.

Lemma pure39 sz2l2 sz2 sz1l2 : 0 <= sz2l2 -> 0 <= sz2 -> 0 <= 1 + sz1l2 + sz2l2 -> 0 <= sz1l2 -> 0 <= 1 + sz2l2 + sz2. Admitted.
Hint Resolve pure39: ssl_pure.
Lemma pure40 sz1l2 sz2l2 sz2 : 0 <= sz2l2 -> 0 <= sz2 -> 0 <= 1 + sz1l2 + sz2l2 -> 0 <= sz1l2 -> sz1l2 + 1 + sz2l2 + sz2 == 1 + sz1l2 + sz2l2 + sz2. Admitted.
Hint Resolve pure40: ssl_pure.
Lemma pure41 lo2l2 v2 vl22 hi2l2 lo2 hi1l2 : (if hi2l2 <= vl22 then vl22 else hi2l2) <= v2 -> hi1l2 <= vl22 -> vl22 <= 7 -> 0 <= v2 -> v2 <= lo2 -> 0 <= vl22 -> vl22 <= lo2l2 -> v2 <= 7 -> hi2l2 <= v2. Admitted.
Hint Resolve pure41: ssl_pure.
Lemma pure42 lo2l2 v2 vl22 hi2l2 lo2 hi1l2 : (if hi2l2 <= vl22 then vl22 else hi2l2) <= v2 -> hi1l2 <= vl22 -> vl22 <= 7 -> 0 <= v2 -> v2 <= lo2 -> 0 <= vl22 -> vl22 <= lo2l2 -> v2 <= 7 -> vl22 <= (if v2 <= lo2l2 then v2 else lo2l2). Admitted.
Hint Resolve pure42: ssl_pure.

Definition bst_right_rotate_type :=
  forall (vprogs : ptr * ptr),
  {(vghosts : nat * nat * nat * nat * ptr * nat * nat * ptr * nat * ptr)},
  STsep (
    fun h =>
      let: (x, retv) := vprogs in
      let: (sz1, sz2, v, hi1, l, lo2, lo1, r, hi2, unused) := vghosts in
      exists h_bst_lsz1lo1hi1_a h_bst_rsz2lo2hi2_b,
      0 <= sz1 /\ 0 <= sz2 /\ 0 <= v /\ hi1 <= v /\ (l == null) = false /\ v <= 7 /\ v <= lo2 /\ h = retv :-> unused \+ x :-> v \+ x .+ 1 :-> l \+ x .+ 2 :-> r \+ h_bst_lsz1lo1hi1_a \+ h_bst_rsz2lo2hi2_b /\ bst l sz1 lo1 hi1 h_bst_lsz1lo1hi1_a /\ bst r sz2 lo2 hi2 h_bst_rsz2lo2hi2_b,
    [vfun (_: unit) h =>
      let: (x, retv) := vprogs in
      let: (sz1, sz2, v, hi1, l, lo2, lo1, r, hi2, unused) := vghosts in
      exists sz3 sz4 v3 hi3 lo4 l3 lo3 hi4 y,
      exists h_bst_l3sz3lo3hi3_527 h_bst_xsz4lo4hi4_528,
      0 <= sz3 /\ 0 <= sz4 /\ 0 <= v3 /\ hi3 <= v3 /\ sz3 + sz4 == sz1 + sz2 /\ v3 <= 7 /\ v3 <= lo4 /\ h = retv :-> y \+ y :-> v3 \+ y .+ 1 :-> l3 \+ y .+ 2 :-> x \+ h_bst_l3sz3lo3hi3_527 \+ h_bst_xsz4lo4hi4_528 /\ bst l3 sz3 lo3 hi3 h_bst_l3sz3lo3hi3_527 /\ bst x sz4 lo4 hi4 h_bst_xsz4lo4hi4_528
    ]).

Program Definition bst_right_rotate : bst_right_rotate_type :=
  Fix (fun (bst_right_rotate : bst_right_rotate_type) vprogs =>
    let: (x, retv) := vprogs in
    Do (
      unused2 <-- @read ptr retv;
      v2 <-- @read nat x;
      l2 <-- @read ptr (x .+ 1);
      r2 <-- @read ptr (x .+ 2);
      if l2 == null
      then
        ret tt
      else
        vl22 <-- @read nat l2;
        ll22 <-- @read ptr (l2 .+ 1);
        rl22 <-- @read ptr (l2 .+ 2);
        (l2 .+ 2) ::= x;;
        retv ::= l2;;
        (x .+ 1) ::= rl22;;
        ret tt
    )).
Obligation Tactic := intro; move=>[x retv]; ssl_program_simpl.
Next Obligation.
ssl_ghostelim_pre.
move=>[[[[[[[[[sz1 sz2] v] hi1] l] lo2] lo1] r] hi2] unused].
ex_elim h_bst_lsz1lo1hi1_a h_bst_rsz2lo2hi2_b.
move=>[phi_self0] [phi_self1] [phi_self2] [phi_self3] [phi_self4] [phi_self5] [phi_self6].
move=>[sigma_self].
subst h_self.
move=>[H_bst_lsz1lo1hi1_a H_bst_rsz2lo2hi2_b].
ssl_ghostelim_post.
ssl_read retv.
try rename unused into unused2.
ssl_read x.
try rename v into v2.
ssl_read (x .+ 1).
try rename l into l2.
try rename h_bst_lsz1lo1hi1_a into h_bst_l2sz1lo1hi1_a.
try rename H_bst_lsz1lo1hi1_a into H_bst_l2sz1lo1hi1_a.
ssl_read (x .+ 2).
try rename r into r2.
try rename h_bst_rsz2lo2hi2_b into h_bst_r2sz2lo2hi2_b.
try rename H_bst_rsz2lo2hi2_b into H_bst_r2sz2lo2hi2_b.
ssl_open (l2 == null) H_bst_l2sz1lo1hi1_a.
move=>[phi_bst_l2sz1lo1hi1_a0] [phi_bst_l2sz1lo1hi1_a1] [phi_bst_l2sz1lo1hi1_a2].
move=>[sigma_bst_l2sz1lo1hi1_a].
subst h_bst_l2sz1lo1hi1_a.
shelve.
ex_elim sz1l2 sz2l2 vl2 hi2l2 hi1l2.
ex_elim lo1l2 lo2l2 ll2 rl2.
ex_elim h_bst_ll2sz1l2lo1l2hi1l2_525l2 h_bst_rl2sz2l2lo2l2hi2l2_526l2.
move=>[phi_bst_l2sz1lo1hi1_a0] [phi_bst_l2sz1lo1hi1_a1] [phi_bst_l2sz1lo1hi1_a2] [phi_bst_l2sz1lo1hi1_a3] [phi_bst_l2sz1lo1hi1_a4] [phi_bst_l2sz1lo1hi1_a5] [phi_bst_l2sz1lo1hi1_a6] [phi_bst_l2sz1lo1hi1_a7] [phi_bst_l2sz1lo1hi1_a8].
move=>[sigma_bst_l2sz1lo1hi1_a].
subst h_bst_l2sz1lo1hi1_a.
move=>[H_bst_ll2sz1l2lo1l2hi1l2_525l2 H_bst_rl2sz2l2lo2l2hi2l2_526l2].
shelve.
Unshelve.
ssl_inconsistency.
try rename h_bst_l2sz1lo1hi1_a into h_bst_l2sz1lo1hi2l2vl2vl2hi2l2_a.
try rename H_bst_l2sz1lo1hi1_a into H_bst_l2sz1lo1hi2l2vl2vl2hi2l2_a.
try rename h_bst_l2sz1lo1hi2l2vl2vl2hi2l2_a into h_bst_l2sz1vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a.
try rename H_bst_l2sz1lo1hi2l2vl2vl2hi2l2_a into H_bst_l2sz1vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a.
try rename h_bst_l2sz1vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a into h_bst_l2sz1l2sz2l2vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a.
try rename H_bst_l2sz1vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a into H_bst_l2sz1l2sz2l2vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a.
ssl_read l2.
try rename vl2 into vl22.
try rename h_bst_l2sz1l2sz2l2vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a into h_bst_l2sz1l2sz2l2vl22lo1l2vl22lo1l2hi2l2vl22vl22hi2l2_a.
try rename H_bst_l2sz1l2sz2l2vl2lo1l2vl2lo1l2hi2l2vl2vl2hi2l2_a into H_bst_l2sz1l2sz2l2vl22lo1l2vl22lo1l2hi2l2vl22vl22hi2l2_a.
ssl_read (l2 .+ 1).
try rename ll2 into ll22.
try rename h_bst_ll2sz1l2lo1l2hi1l2_525l2 into h_bst_ll22sz1l2lo1l2hi1l2_525l2.
try rename H_bst_ll2sz1l2lo1l2hi1l2_525l2 into H_bst_ll22sz1l2lo1l2hi1l2_525l2.
ssl_read (l2 .+ 2).
try rename rl2 into rl22.
try rename h_bst_rl2sz2l2lo2l2hi2l2_526l2 into h_bst_rl22sz2l2lo2l2hi2l2_526l2.
try rename H_bst_rl2sz2l2lo2l2hi2l2_526l2 into H_bst_rl22sz2l2lo2l2hi2l2_526l2.
try rename h_bst_xsz4lo4hi4_528 into h_bst_xsz4lo4hi21xv1xv1xhi21x_528.
try rename H_bst_xsz4lo4hi4_528 into H_bst_xsz4lo4hi21xv1xv1xhi21x_528.
try rename h_bst_xsz4lo4hi21xv1xv1xhi21x_528 into h_bst_xsz4v1xlo11xv1xlo11xhi21xv1xv1xhi21x_528.
try rename H_bst_xsz4lo4hi21xv1xv1xhi21x_528 into H_bst_xsz4v1xlo11xv1xlo11xhi21xv1xv1xhi21x_528.
try rename h_bst_xsz4v1xlo11xv1xlo11xhi21xv1xv1xhi21x_528 into h_bst_xsz11xsz21xv1xlo11xv1xlo11xhi21xv1xv1xhi21x_528.
try rename H_bst_xsz4v1xlo11xv1xlo11xhi21xv1xv1xhi21x_528 into H_bst_xsz11xsz21xv1xlo11xv1xlo11xhi21xv1xv1xhi21x_528.
try rename h_bst_l3sz3lo3hi3_527 into h_bst_l3sz3lo3hi3_525l2.
try rename H_bst_l3sz3lo3hi3_527 into H_bst_l3sz3lo3hi3_525l2.
try rename h_bst_l3sz3lo3hi3_525l2 into h_bst_l3sz3lo3hi1l2_525l2.
try rename H_bst_l3sz3lo3hi3_525l2 into H_bst_l3sz3lo3hi1l2_525l2.
try rename h_bst_l3sz3lo3hi1l2_525l2 into h_bst_ll22sz3lo3hi1l2_525l2.
try rename H_bst_l3sz3lo3hi1l2_525l2 into H_bst_ll22sz3lo3hi1l2_525l2.
try rename h_bst_ll22sz3lo3hi1l2_525l2 into h_bst_ll22sz3lo1l2hi1l2_525l2.
try rename H_bst_ll22sz3lo3hi1l2_525l2 into H_bst_ll22sz3lo1l2hi1l2_525l2.
try rename h_bst_ll22sz3lo1l2hi1l2_525l2 into h_bst_ll22sz1l2lo1l2hi1l2_525l2.
try rename H_bst_ll22sz3lo1l2hi1l2_525l2 into H_bst_ll22sz1l2lo1l2hi1l2_525l2.
try rename h_bst_l1xsz11xlo11xhi11x_525x into h_bst_l1xsz11xlo11xhi11x_526l2.
try rename H_bst_l1xsz11xlo11xhi11x_525x into H_bst_l1xsz11xlo11xhi11x_526l2.
try rename h_bst_l1xsz11xlo11xhi11x_526l2 into h_bst_l1xsz11xlo11xhi2l2_526l2.
try rename H_bst_l1xsz11xlo11xhi11x_526l2 into H_bst_l1xsz11xlo11xhi2l2_526l2.
try rename h_bst_l1xsz11xlo11xhi2l2_526l2 into h_bst_rl22sz11xlo11xhi2l2_526l2.
try rename H_bst_l1xsz11xlo11xhi2l2_526l2 into H_bst_rl22sz11xlo11xhi2l2_526l2.
try rename h_bst_rl22sz11xlo11xhi2l2_526l2 into h_bst_rl22sz11xlo2l2hi2l2_526l2.
try rename H_bst_rl22sz11xlo11xhi2l2_526l2 into H_bst_rl22sz11xlo2l2hi2l2_526l2.
try rename h_bst_xsz11xsz21xv1xlo11xv1xlo11xhi21xv1xv1xhi21x_528 into h_bst_xsz11xsz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528.
try rename H_bst_xsz11xsz21xv1xlo11xv1xlo11xhi21xv1xv1xhi21x_528 into H_bst_xsz11xsz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528.
try rename h_bst_xsz11xsz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528 into h_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528.
try rename H_bst_xsz11xsz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528 into H_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528.
try rename h_bst_rl22sz11xlo2l2hi2l2_526l2 into h_bst_rl22sz2l2lo2l2hi2l2_526l2.
try rename H_bst_rl22sz11xlo2l2hi2l2_526l2 into H_bst_rl22sz2l2lo2l2hi2l2_526l2.
try rename h_bst_r1xsz21xlo21xhi21x_526x into h_bst_r1xsz21xlo21xhi21x_b.
try rename H_bst_r1xsz21xlo21xhi21x_526x into H_bst_r1xsz21xlo21xhi21x_b.
try rename h_bst_r1xsz21xlo21xhi21x_b into h_bst_r1xsz21xlo21xhi2_b.
try rename H_bst_r1xsz21xlo21xhi21x_b into H_bst_r1xsz21xlo21xhi2_b.
try rename h_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528 into h_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi2v1xv1xhi2_528.
try rename H_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi21xv1xv1xhi21x_528 into H_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi2v1xv1xhi2_528.
try rename h_bst_r1xsz21xlo21xhi2_b into h_bst_r1xsz21xlo2hi2_b.
try rename H_bst_r1xsz21xlo21xhi2_b into H_bst_r1xsz21xlo2hi2_b.
try rename h_bst_r1xsz21xlo2hi2_b into h_bst_r2sz21xlo2hi2_b.
try rename H_bst_r1xsz21xlo2hi2_b into H_bst_r2sz21xlo2hi2_b.
try rename h_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi2v1xv1xhi2_528 into h_bst_xsz2l2sz2v1xlo2l2v1xlo2l2hi2v1xv1xhi2_528.
try rename H_bst_xsz2l2sz21xv1xlo2l2v1xlo2l2hi2v1xv1xhi2_528 into H_bst_xsz2l2sz2v1xlo2l2v1xlo2l2hi2v1xv1xhi2_528.
try rename h_bst_r2sz21xlo2hi2_b into h_bst_r2sz2lo2hi2_b.
try rename H_bst_r2sz21xlo2hi2_b into H_bst_r2sz2lo2hi2_b.
ssl_write (l2 .+ 2).
ssl_write_post (l2 .+ 2).
ssl_write retv.
ssl_write_post retv.
ssl_write (x .+ 1).
ssl_write_post (x .+ 1).
try rename h_bst_xsz2l2sz2v1xlo2l2v1xlo2l2hi2v1xv1xhi2_528 into h_bst_xsz2l2sz2v2lo2l2v2lo2l2hi2v2v2hi2_528.
try rename H_bst_xsz2l2sz2v1xlo2l2v1xlo2l2hi2v1xv1xhi2_528 into H_bst_xsz2l2sz2v2lo2l2v2lo2l2hi2v2v2hi2_528.
ssl_emp;
exists (sz1l2), (1 + sz2l2 + sz2), (vl22), (hi1l2), ((if v2 <= lo2l2 then v2 else lo2l2)), (ll22), (lo1l2), ((if hi2 <= v2 then v2 else hi2)), (l2);
exists (h_bst_ll22sz1l2lo1l2hi1l2_525l2);
exists (x :-> v2 \+ x .+ 1 :-> rl22 \+ x .+ 2 :-> r2 \+ h_bst_rl22sz2l2lo2l2hi2l2_526l2 \+ h_bst_r2sz2lo2hi2_b);
sslauto.
unfold_constructor 2;
exists (sz2l2), (sz2), (v2), (hi2), (hi2l2), (lo2l2), (lo2), (rl22), (r2), (h_bst_rl22sz2l2lo2l2hi2l2_526l2), (h_bst_r2sz2lo2hi2_b);
sslauto.
Qed.