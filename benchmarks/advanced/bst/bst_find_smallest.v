From mathcomp
Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From fcsl
Require Import prelude pred pcm unionmap heap.
From HTT
Require Import stmod stsep stlog stlogR.
From SSL
Require Import core.
From Hammer Require Import Hammer.
(* Configure Hammer *)
Unset Hammer Eprover.
Unset Hammer Vampire.
Add Search Blacklist "fcsl.".
Add Search Blacklist "HTT.".
Add Search Blacklist "Coq.ssr.ssrfun".
Add Search Blacklist "mathcomp.ssreflect.ssrfun".
Add Search Blacklist "mathcomp.ssreflect.bigop".
Add Search Blacklist "mathcomp.ssreflect.choice".
Add Search Blacklist "mathcomp.ssreflect.div".
Add Search Blacklist "mathcomp.ssreflect.finfun".
Add Search Blacklist "mathcomp.ssreflect.fintype".
Add Search Blacklist "mathcomp.ssreflect.path".
Add Search Blacklist "mathcomp.ssreflect.tuple".


Require Import common.

Lemma pure43 : (0) = (0). intros; hammer. Qed.
Hint Resolve pure43: ssl_pure.
Lemma pure44 : (7) = (7). intros; hammer. Qed.
Hint Resolve pure44: ssl_pure.
Lemma pure45 (lo2x : nat) (vx2 : nat) (hi1x : nat) (lo1x : nat) (hi2x : nat) : ((if (hi2x) <= (vx2) then vx2 else hi2x)) <= (7) -> (vx2) <= (lo2x) -> (0) <= ((if (vx2) <= (lo1x) then vx2 else lo1x)) -> (0) <= (vx2) -> (hi1x) <= (vx2) -> (vx2) <= (7) -> (0) <= (lo1x). intros; hammer. Qed.
Hint Resolve pure45: ssl_pure.
Lemma pure46 (lo2x : nat) (vx2 : nat) (hi1x : nat) (lo1x : nat) (hi2x : nat) : ((if (hi2x) <= (vx2) then vx2 else hi2x)) <= (7) -> (vx2) <= (lo2x) -> (0) <= ((if (vx2) <= (lo1x) then vx2 else lo1x)) -> (0) <= (vx2) -> (hi1x) <= (vx2) -> (vx2) <= (7) -> (hi1x) <= (7). intros; hammer. Qed.
Hint Resolve pure46: ssl_pure.
Lemma pure47 (sz1x : nat) (sz2x : nat) : (0) <= (((1) + (sz1x)) + (sz2x)) -> (0) <= (sz2x) -> (0) <= (sz1x) -> (((1) + (sz1x)) + (sz2x)) = (((1) + (sz1x)) + (sz2x)). intros; hammer. Qed.
Hint Resolve pure47: ssl_pure.
Lemma pure48 (lo2x : nat) (vx2 : nat) (hi1x : nat) (hi2x : nat) (lo1x2 : nat) : ((if (hi2x) <= (vx2) then vx2 else hi2x)) <= (7) -> (vx2) <= (lo2x) -> (0) <= (vx2) -> (0) <= ((if (vx2) <= (lo1x2) then vx2 else lo1x2)) -> (hi1x) <= (vx2) -> (vx2) <= (7) -> ((if (vx2) <= (lo1x2) then vx2 else lo1x2)) = ((if (vx2) <= (lo1x2) then vx2 else lo1x2)). intros; hammer. Qed.
Hint Resolve pure48: ssl_pure.
Lemma pure49 (lo2x : nat) (vx2 : nat) (hi1x : nat) (hi2x : nat) (lo1x2 : nat) : ((if (hi2x) <= (vx2) then vx2 else hi2x)) <= (7) -> (vx2) <= (lo2x) -> (0) <= (vx2) -> (0) <= ((if (vx2) <= (lo1x2) then vx2 else lo1x2)) -> (hi1x) <= (vx2) -> (vx2) <= (7) -> ((if (hi2x) <= (vx2) then vx2 else hi2x)) = ((if (hi2x) <= (vx2) then vx2 else hi2x)). intros; hammer. Qed.
Hint Resolve pure49: ssl_pure.

Definition bst_find_smallest_type :=
  forall (vprogs : ptr * ptr),
  {(vghosts : nat * nat * nat * ptr)},
  STsep (
    fun h =>
      let: (x, retv) := vprogs in
      let: (lo, sz, hi, unused) := vghosts in
      exists h_bst_xszlohi_a,
      (0) <= (lo) /\ (0) <= (sz) /\ (hi) <= (7) /\ h = retv :-> unused \+ h_bst_xszlohi_a /\ bst x sz lo hi h_bst_xszlohi_a,
    [vfun (_: unit) h =>
      let: (x, retv) := vprogs in
      let: (lo, sz, hi, unused) := vghosts in
      exists h_bst_xszlohi_c,
      h = retv :-> lo \+ h_bst_xszlohi_c /\ bst x sz lo hi h_bst_xszlohi_c
    ]).

Program Definition bst_find_smallest : bst_find_smallest_type :=
  Fix (fun (bst_find_smallest : bst_find_smallest_type) vprogs =>
    let: (x, retv) := vprogs in
    Do (
      unused2 <-- @read ptr retv;
      if (x) == (null)
      then
        retv ::= 7;;
        ret tt
      else
        vx2 <-- @read nat x;
        lx2 <-- @read ptr (x .+ 1);
        rx2 <-- @read ptr (x .+ 2);
        bst_find_smallest (lx2, retv);;
        lo1x2 <-- @read nat retv;
        retv ::= (if (vx2) <= (lo1x2) then vx2 else lo1x2);;
        ret tt
    )).
Obligation Tactic := intro; move=>[x retv]; ssl_program_simpl.
Next Obligation.
ssl_ghostelim_pre.
move=>[[[lo sz] hi] unused].
ex_elim h_bst_xszlohi_a.
move=>[phi_self0] [phi_self1] [phi_self2].
move=>[sigma_self].
subst h_self.
move=>H_bst_xszlohi_a.
ssl_ghostelim_post.
ssl_read retv.
try rename unused into unused2.
ssl_open ((x) == (null)) H_bst_xszlohi_a.
move=>[phi_bst_xszlohi_a0] [phi_bst_xszlohi_a1] [phi_bst_xszlohi_a2].
move=>[sigma_bst_xszlohi_a].
subst h_bst_xszlohi_a.
try rename h_bst_xszlohi_a into h_bst_xszlo_a.
try rename H_bst_xszlohi_a into H_bst_xszlo_a.
try rename h_bst_xszlohi_c into h_bst_xszlo_c.
try rename H_bst_xszlohi_c into H_bst_xszlo_c.
try rename h_bst_xszlo_a into h_bst_xsz_a.
try rename H_bst_xszlo_a into H_bst_xsz_a.
try rename h_bst_xszlo_c into h_bst_xsz_c.
try rename H_bst_xszlo_c into H_bst_xsz_c.
try rename h_bst_xsz_a into h_bst_x_a.
try rename H_bst_xsz_a into H_bst_x_a.
try rename h_bst_xsz_c into h_bst_x_c.
try rename H_bst_xsz_c into H_bst_x_c.
ssl_write retv.
ssl_write_post retv.
ssl_emp;
exists (empty);
sslauto.
ssl_close 1;
sslauto.
ex_elim sz1x sz2x vx hi2x hi1x.
ex_elim lo1x lo2x lx rx.
ex_elim h_bst_lxsz1xlo1xhi1x_533x h_bst_rxsz2xlo2xhi2x_534x.
move=>[phi_bst_xszlohi_a0] [phi_bst_xszlohi_a1] [phi_bst_xszlohi_a2] [phi_bst_xszlohi_a3] [phi_bst_xszlohi_a4] [phi_bst_xszlohi_a5] [phi_bst_xszlohi_a6] [phi_bst_xszlohi_a7] [phi_bst_xszlohi_a8].
move=>[sigma_bst_xszlohi_a].
subst h_bst_xszlohi_a.
move=>[H_bst_lxsz1xlo1xhi1x_533x H_bst_rxsz2xlo2xhi2x_534x].
try rename h_bst_xszlohi_a into h_bst_xszlohi2xvxvxhi2x_a.
try rename H_bst_xszlohi_a into H_bst_xszlohi2xvxvxhi2x_a.
try rename h_bst_xszlohi_c into h_bst_xszlohi2xvxvxhi2x_c.
try rename H_bst_xszlohi_c into H_bst_xszlohi2xvxvxhi2x_c.
try rename h_bst_xszlohi2xvxvxhi2x_c into h_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_c.
try rename H_bst_xszlohi2xvxvxhi2x_c into H_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_c.
try rename h_bst_xszlohi2xvxvxhi2x_a into h_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_a.
try rename H_bst_xszlohi2xvxvxhi2x_a into H_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_a.
try rename h_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_a into h_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_a.
try rename H_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_a into H_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_a.
try rename h_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_c into h_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_c.
try rename H_bst_xszvxlo1xvxlo1xhi2xvxvxhi2x_c into H_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_c.
ssl_read x.
try rename vx into vx2.
try rename h_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_a into h_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_a.
try rename H_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_a into H_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_a.
try rename h_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_c into h_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_c.
try rename H_bst_xsz1xsz2xvxlo1xvxlo1xhi2xvxvxhi2x_c into H_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_c.
ssl_read (x .+ 1).
try rename lx into lx2.
try rename h_bst_lxsz1xlo1xhi1x_533x into h_bst_lx2sz1xlo1xhi1x_533x.
try rename H_bst_lxsz1xlo1xhi1x_533x into H_bst_lx2sz1xlo1xhi1x_533x.
ssl_read (x .+ 2).
try rename rx into rx2.
try rename h_bst_rxsz2xlo2xhi2x_534x into h_bst_rx2sz2xlo2xhi2x_534x.
try rename H_bst_rxsz2xlo2xhi2x_534x into H_bst_rx2sz2xlo2xhi2x_534x.
try rename h_bst_x1sz1lo1hi1_a1 into h_bst_lx2sz1xlo1xhi1x_533x.
try rename H_bst_x1sz1lo1hi1_a1 into H_bst_lx2sz1xlo1xhi1x_533x.
ssl_call_pre (retv :-> unused2 \+ h_bst_lx2sz1xlo1xhi1x_533x).
ssl_call (lo1x, sz1x, hi1x, unused2).
exists (h_bst_lx2sz1xlo1xhi1x_533x);
sslauto.
ssl_frame_unfold.
move=>h_call0.
ex_elim h_bst_lx2sz1xlo1xhi1x_c1.
move=>[sigma_call0].
subst h_call0.
move=>H_bst_lx2sz1xlo1xhi1x_c1.
store_valid.
ssl_read retv.
try rename lo1x into lo1x2.
try rename h_bst_lx2sz1xlo1xhi1x_c1 into h_bst_lx2sz1xlo1x2hi1x_c1.
try rename H_bst_lx2sz1xlo1xhi1x_c1 into H_bst_lx2sz1xlo1x2hi1x_c1.
try rename h_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_a into h_bst_xsz1xsz2xvx2lo1x2vx2lo1x2hi2xvx2vx2hi2x_a.
try rename H_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_a into H_bst_xsz1xsz2xvx2lo1x2vx2lo1x2hi2xvx2vx2hi2x_a.
try rename h_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_c into h_bst_xsz1xsz2xvx2lo1x2vx2lo1x2hi2xvx2vx2hi2x_c.
try rename H_bst_xsz1xsz2xvx2lo1xvx2lo1xhi2xvx2vx2hi2x_c into H_bst_xsz1xsz2xvx2lo1x2vx2lo1x2hi2xvx2vx2hi2x_c.
try rename h_bst_lx2sz1xlo1xhi1x_533x into h_bst_lx2sz1xlo1x2hi1x_533x.
try rename H_bst_lx2sz1xlo1xhi1x_533x into H_bst_lx2sz1xlo1x2hi1x_533x.
try rename h_bst_lx1sz11xlo11xhi11x_533x1 into h_bst_lx2sz1xlo1x2hi1x_c1.
try rename H_bst_lx1sz11xlo11xhi11x_533x1 into H_bst_lx2sz1xlo1x2hi1x_c1.
try rename h_bst_rx1sz2x1lo2x1hi2x1_534x1 into h_bst_rx2sz2xlo2xhi2x_534x.
try rename H_bst_rx1sz2x1lo2x1hi2x1_534x1 into H_bst_rx2sz2xlo2xhi2x_534x.
ssl_write retv.
ssl_write_post retv.
ssl_emp;
exists (x :-> vx2 \+ x .+ 1 :-> lx2 \+ x .+ 2 :-> rx2 \+ h_bst_lx2sz1xlo1x2hi1x_c1 \+ h_bst_rx2sz2xlo2xhi2x_534x);
sslauto.
ssl_close 2;
exists (sz1x), (sz2x), (vx2), (hi2x), (hi1x), (lo1x2), (lo2x), (lx2), (rx2), (h_bst_lx2sz1xlo1x2hi1x_c1), (h_bst_rx2sz2xlo2xhi2x_534x);
sslauto.
ssl_frame_unfold.
ssl_frame_unfold.
Qed.