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

Lemma pure11 : @perm_eq nat_eqType (@nil nat) (@nil nat). intros; hammer. Qed.
Hint Resolve pure11: ssl_pure.
Lemma pure12 (vx22 : nat) : @perm_eq nat_eqType ([:: vx22]) ([:: vx22]). intros; hammer. Qed.
Hint Resolve pure12: ssl_pure.
Lemma pure13 (vx22 : nat) : @perm_eq nat_eqType ([:: vx22]) ([:: vx22]). intros; hammer. Qed.
Hint Resolve pure13: ssl_pure.
Lemma pure14 (vx22 : nat) (vy122 : nat) (s1y12 : seq nat) : @perm_eq nat_eqType (([:: vx22]) ++ (([:: vy122]) ++ (s1y12))) (([:: vx22]) ++ (([:: vy122]) ++ (s1y12))). solve_perm_eq. (* intros; hammer. *) Qed.
Hint Resolve pure14: ssl_pure.
Lemma pure15 (vx22 : nat) (vy122 : nat) (s1y12 : seq nat) : @perm_eq nat_eqType (([:: vx22]) ++ (([:: vy122]) ++ (s1y12))) (([:: vy122]) ++ (([:: vx22]) ++ (s1y12))). solve_perm_eq. (* intros; hammer. *) Qed.
Hint Resolve pure15: ssl_pure.

Definition dll_copy_type :=
  forall (vprogs : ptr),
  {(vghosts : ptr * ptr * seq nat)},
  STsep (
    fun h =>
      let: (r) := vprogs in
      let: (x, a, s) := vghosts in
      exists h_dll_xas_522,
      h = r :-> x \+ h_dll_xas_522 /\ dll x a s h_dll_xas_522,
    [vfun (_: unit) h =>
      let: (r) := vprogs in
      let: (x, a, s) := vghosts in
      exists y b,
      exists h_dll_xas_523 h_dll_ybs_524,
      h = r :-> y \+ h_dll_xas_523 \+ h_dll_ybs_524 /\ dll x a s h_dll_xas_523 /\ dll y b s h_dll_ybs_524
    ]).

Program Definition dll_copy : dll_copy_type :=
  Fix (fun (dll_copy : dll_copy_type) vprogs =>
    let: (r) := vprogs in
    Do (
      x2 <-- @read ptr r;
      if (x2) == (null)
      then
        ret tt
      else
        vx22 <-- @read nat x2;
        wx22 <-- @read ptr (x2 .+ 1);
        a2 <-- @read ptr (x2 .+ 2);
        r ::= wx22;;
        dll_copy (r);;
        y12 <-- @read ptr r;
        if (y12) == (null)
        then
          y2 <-- allocb null 3;
          r ::= y2;;
          (y2 .+ 1) ::= null;;
          y2 ::= vx22;;
          (y2 .+ 2) ::= null;;
          ret tt
        else
          vy122 <-- @read nat y12;
          wy122 <-- @read ptr (y12 .+ 1);
          b12 <-- @read ptr (y12 .+ 2);
          y2 <-- allocb null 3;
          (y12 .+ 2) ::= y2;;
          r ::= y2;;
          (y2 .+ 1) ::= y12;;
          y12 ::= vx22;;
          y2 ::= vy122;;
          (y2 .+ 2) ::= null;;
          ret tt
    )).
Obligation Tactic := intro; move=>r; ssl_program_simpl.
Next Obligation.
ssl_ghostelim_pre.
move=>[[x a] s].
ex_elim h_dll_xas_522.
move=>[sigma_self].
subst h_self.
move=>H_dll_xas_522.
ssl_ghostelim_post.
ssl_read r.
try rename x into x2.
try rename h_dll_xas_522 into h_dll_x2as_522.
try rename H_dll_xas_522 into H_dll_x2as_522.
try rename h_dll_xas_523 into h_dll_x2as_523.
try rename H_dll_xas_523 into H_dll_x2as_523.
ssl_open ((x2) == (null)) H_dll_x2as_522.
move=>[phi_dll_x2as_5220].
move=>[sigma_dll_x2as_522].
subst h_dll_x2as_522.
try rename h_dll_x2as_522 into h_dll_x2a_522.
try rename H_dll_x2as_522 into H_dll_x2a_522.
try rename h_dll_x2as_523 into h_dll_x2a_523.
try rename H_dll_x2as_523 into H_dll_x2a_523.
try rename h_dll_ybs_524 into h_dll_yb_524.
try rename H_dll_ybs_524 into H_dll_yb_524.
try rename h_dll_yb_524 into h_dll_b_524.
try rename H_dll_yb_524 into H_dll_b_524.
ssl_emp;
exists (null), (null);
exists (empty);
exists (empty);
sslauto.
ssl_close 1;
sslauto.
ssl_close 1;
sslauto.
ex_elim vx2 s1x2 wx2.
ex_elim h_dll_wx2x2s1x2_520x2.
move=>[phi_dll_x2as_5220].
move=>[sigma_dll_x2as_522].
subst h_dll_x2as_522.
move=>H_dll_wx2x2s1x2_520x2.
try rename h_dll_x2as_522 into h_dll_x2avx2s1x2_522.
try rename H_dll_x2as_522 into H_dll_x2avx2s1x2_522.
try rename h_dll_x2as_523 into h_dll_x2avx2s1x2_523.
try rename H_dll_x2as_523 into H_dll_x2avx2s1x2_523.
try rename h_dll_ybs_524 into h_dll_ybvx2s1x2_524.
try rename H_dll_ybs_524 into H_dll_ybvx2s1x2_524.
ssl_read x2.
try rename vx2 into vx22.
try rename h_dll_x2avx2s1x2_523 into h_dll_x2avx22s1x2_523.
try rename H_dll_x2avx2s1x2_523 into H_dll_x2avx22s1x2_523.
try rename h_dll_ybvx2s1x2_524 into h_dll_ybvx22s1x2_524.
try rename H_dll_ybvx2s1x2_524 into H_dll_ybvx22s1x2_524.
try rename h_dll_x2avx2s1x2_522 into h_dll_x2avx22s1x2_522.
try rename H_dll_x2avx2s1x2_522 into H_dll_x2avx22s1x2_522.
ssl_read (x2 .+ 1).
try rename wx2 into wx22.
try rename h_dll_wx2x2s1x2_520x2 into h_dll_wx22x2s1x2_520x2.
try rename H_dll_wx2x2s1x2_520x2 into H_dll_wx22x2s1x2_520x2.
ssl_read (x2 .+ 2).
try rename a into a2.
try rename h_dll_x2avx22s1x2_523 into h_dll_x2a2vx22s1x2_523.
try rename H_dll_x2avx22s1x2_523 into H_dll_x2a2vx22s1x2_523.
try rename h_dll_x2avx22s1x2_522 into h_dll_x2a2vx22s1x2_522.
try rename H_dll_x2avx22s1x2_522 into H_dll_x2a2vx22s1x2_522.
try rename h_dll_x1a1s1_5221 into h_dll_wx22x2s1x2_520x2.
try rename H_dll_x1a1s1_5221 into H_dll_wx22x2s1x2_520x2.
ssl_write r.
ssl_call_pre (r :-> wx22 \+ h_dll_wx22x2s1x2_520x2).
ssl_call (wx22, x2, s1x2).
exists (h_dll_wx22x2s1x2_520x2);
sslauto.
ssl_frame_unfold.
move=>h_call0.
ex_elim y1 b1.
ex_elim h_dll_wx22x2s1x2_5231 h_dll_y1b1s1x2_5241.
move=>[sigma_call0].
subst h_call0.
move=>[H_dll_wx22x2s1x2_5231 H_dll_y1b1s1x2_5241].
store_valid.
ssl_read r.
try rename y1 into y12.
try rename h_dll_y1b1s1x2_5241 into h_dll_y12b1s1x2_5241.
try rename H_dll_y1b1s1x2_5241 into H_dll_y12b1s1x2_5241.
ssl_open ((y12) == (null)) H_dll_y12b1s1x2_5241.
move=>[phi_dll_y12b1s1x2_52410].
move=>[sigma_dll_y12b1s1x2_5241].
subst h_dll_y12b1s1x2_5241.
try rename h_dll_ybvx22s1x2_524 into h_dll_ybvx22_524.
try rename H_dll_ybvx22s1x2_524 into H_dll_ybvx22_524.
try rename h_dll_x2a2vx22s1x2_523 into h_dll_x2a2vx22_523.
try rename H_dll_x2a2vx22s1x2_523 into H_dll_x2a2vx22_523.
try rename h_dll_wx22x2s1x2_520x2 into h_dll_wx22x2_520x2.
try rename H_dll_wx22x2s1x2_520x2 into H_dll_wx22x2_520x2.
try rename h_dll_wx22x2s1x2_5231 into h_dll_wx22x2_5231.
try rename H_dll_wx22x2s1x2_5231 into H_dll_wx22x2_5231.
try rename h_dll_y12b1s1x2_5241 into h_dll_y12b1_5241.
try rename H_dll_y12b1s1x2_5241 into H_dll_y12b1_5241.
try rename h_dll_x2a2vx22s1x2_522 into h_dll_x2a2vx22_522.
try rename H_dll_x2a2vx22s1x2_522 into H_dll_x2a2vx22_522.
try rename h_dll_wyys11y_520y into h_dll_wyy_520y.
try rename H_dll_wyys11y_520y into H_dll_wyy_520y.
try rename h_dll_wyy_520y into h_dll_y_520y.
try rename H_dll_wyy_520y into H_dll_y_520y.
try rename h_dll_wx21x2s11x2_520x21 into h_dll_wx22x2_5231.
try rename H_dll_wx21x2s11x2_520x21 into H_dll_wx22x2_5231.
ssl_alloc y2.
try rename y into y2.
try rename h_dll_y_520y into h_dll_y2_520y.
try rename H_dll_y_520y into H_dll_y2_520y.
try rename h_dll_ybvx22_524 into h_dll_y2bvx22_524.
try rename H_dll_ybvx22_524 into H_dll_y2bvx22_524.
ssl_write r.
ssl_write_post r.
ssl_write (y2 .+ 1).
ssl_write_post (y2 .+ 1).
try rename h_dll_y2bvx22_524 into h_dll_y2vx22_524.
try rename H_dll_y2bvx22_524 into H_dll_y2vx22_524.
ssl_write y2.
ssl_write_post y2.
ssl_write (y2 .+ 2).
ssl_write_post (y2 .+ 2).
ssl_emp;
exists (y2), (null);
exists (x2 :-> vx22 \+ x2 .+ 1 :-> wx22 \+ x2 .+ 2 :-> a2 \+ h_dll_wx22x2_5231);
exists (y2 :-> vx22 \+ y2 .+ 1 :-> null \+ y2 .+ 2 :-> null);
sslauto.
ssl_close 2;
exists (vx22), (@nil nat), (wx22), (h_dll_wx22x2_5231);
sslauto.
shelve.
ssl_close 2;
exists (vx22), (@nil nat), (null), (empty);
sslauto.
shelve.
shelve.
Unshelve.
shelve.
ssl_close 1;
sslauto.
shelve.
Unshelve.
ssl_frame_unfold.
ex_elim vy12 s1y12 wy12.
ex_elim h_dll_wy12y12s1y12_520y12.
move=>[phi_dll_y12b1s1x2_52410].
move=>[sigma_dll_y12b1s1x2_5241].
subst h_dll_y12b1s1x2_5241.
move=>H_dll_wy12y12s1y12_520y12.
try rename h_dll_ybvx22s1x2_524 into h_dll_ybvx22vy12s1y12_524.
try rename H_dll_ybvx22s1x2_524 into H_dll_ybvx22vy12s1y12_524.
try rename h_dll_x2a2vx22s1x2_523 into h_dll_x2a2vx22vy12s1y12_523.
try rename H_dll_x2a2vx22s1x2_523 into H_dll_x2a2vx22vy12s1y12_523.
try rename h_dll_wx22x2s1x2_520x2 into h_dll_wx22x2vy12s1y12_520x2.
try rename H_dll_wx22x2s1x2_520x2 into H_dll_wx22x2vy12s1y12_520x2.
try rename h_dll_wx22x2s1x2_5231 into h_dll_wx22x2vy12s1y12_5231.
try rename H_dll_wx22x2s1x2_5231 into H_dll_wx22x2vy12s1y12_5231.
try rename h_dll_y12b1s1x2_5241 into h_dll_y12b1vy12s1y12_5241.
try rename H_dll_y12b1s1x2_5241 into H_dll_y12b1vy12s1y12_5241.
try rename h_dll_x2a2vx22s1x2_522 into h_dll_x2a2vx22vy12s1y12_522.
try rename H_dll_x2a2vx22s1x2_522 into H_dll_x2a2vx22vy12s1y12_522.
ssl_read y12.
try rename vy12 into vy122.
try rename h_dll_x2a2vx22vy12s1y12_523 into h_dll_x2a2vx22vy122s1y12_523.
try rename H_dll_x2a2vx22vy12s1y12_523 into H_dll_x2a2vx22vy122s1y12_523.
try rename h_dll_ybvx22vy12s1y12_524 into h_dll_ybvx22vy122s1y12_524.
try rename H_dll_ybvx22vy12s1y12_524 into H_dll_ybvx22vy122s1y12_524.
try rename h_dll_wx22x2vy12s1y12_520x2 into h_dll_wx22x2vy122s1y12_520x2.
try rename H_dll_wx22x2vy12s1y12_520x2 into H_dll_wx22x2vy122s1y12_520x2.
try rename h_dll_x2a2vx22vy12s1y12_522 into h_dll_x2a2vx22vy122s1y12_522.
try rename H_dll_x2a2vx22vy12s1y12_522 into H_dll_x2a2vx22vy122s1y12_522.
try rename h_dll_wx22x2vy12s1y12_5231 into h_dll_wx22x2vy122s1y12_5231.
try rename H_dll_wx22x2vy12s1y12_5231 into H_dll_wx22x2vy122s1y12_5231.
try rename h_dll_y12b1vy12s1y12_5241 into h_dll_y12b1vy122s1y12_5241.
try rename H_dll_y12b1vy12s1y12_5241 into H_dll_y12b1vy122s1y12_5241.
ssl_read (y12 .+ 1).
try rename wy12 into wy122.
try rename h_dll_wy12y12s1y12_520y12 into h_dll_wy122y12s1y12_520y12.
try rename H_dll_wy12y12s1y12_520y12 into H_dll_wy122y12s1y12_520y12.
ssl_read (y12 .+ 2).
try rename b1 into b12.
try rename h_dll_y12b1vy122s1y12_5241 into h_dll_y12b12vy122s1y12_5241.
try rename H_dll_y12b1vy122s1y12_5241 into H_dll_y12b12vy122s1y12_5241.
try rename h_dll_wyys11y_520y into h_dll_wyyvwys11wy_520y.
try rename H_dll_wyys11y_520y into H_dll_wyyvwys11wy_520y.
try rename h_dll_wx21x2s11x2_520x21 into h_dll_wx22x2vy122s1y12_5231.
try rename H_dll_wx21x2s11x2_520x21 into H_dll_wx22x2vy122s1y12_5231.
try rename h_dll_wwywys11wy_520wy into h_dll_wy122y12s1y12_520y12.
try rename H_dll_wwywys11wy_520wy into H_dll_wy122y12s1y12_520y12.
try rename h_dll_wyyvwys11wy_520y into h_dll_wyyvwys1y12_520y.
try rename H_dll_wyyvwys11wy_520y into H_dll_wyyvwys1y12_520y.
try rename h_dll_wyyvwys1y12_520y into h_dll_y12yvwys1y12_520y.
try rename H_dll_wyyvwys1y12_520y into H_dll_y12yvwys1y12_520y.
ssl_alloc y2.
try rename y into y2.
try rename h_dll_ybvx22vy122s1y12_524 into h_dll_y2bvx22vy122s1y12_524.
try rename H_dll_ybvx22vy122s1y12_524 into H_dll_y2bvx22vy122s1y12_524.
try rename h_dll_y12yvwys1y12_520y into h_dll_y12y2vwys1y12_520y.
try rename H_dll_y12yvwys1y12_520y into H_dll_y12y2vwys1y12_520y.
ssl_write (y12 .+ 2).
ssl_write_post (y12 .+ 2).
ssl_write r.
ssl_write_post r.
ssl_write (y2 .+ 1).
ssl_write_post (y2 .+ 1).
try rename h_dll_y12y2vwys1y12_520y into h_dll_y12y2vx22s1y12_520y.
try rename H_dll_y12y2vwys1y12_520y into H_dll_y12y2vx22s1y12_520y.
try rename h_dll_y2bvx22vy122s1y12_524 into h_dll_y2vx22vy122s1y12_524.
try rename H_dll_y2bvx22vy122s1y12_524 into H_dll_y2vx22vy122s1y12_524.
ssl_write y12.
ssl_write_post y12.
ssl_write y2.
ssl_write_post y2.
ssl_write (y2 .+ 2).
ssl_write_post (y2 .+ 2).
ssl_emp;
exists (y2), (null);
exists (x2 :-> vx22 \+ x2 .+ 1 :-> wx22 \+ x2 .+ 2 :-> a2 \+ h_dll_wx22x2vy122s1y12_5231);
exists (y2 :-> vy122 \+ y2 .+ 1 :-> y12 \+ y2 .+ 2 :-> null \+ y12 :-> vx22 \+ y12 .+ 1 :-> wy122 \+ y12 .+ 2 :-> y2 \+ h_dll_wy122y12s1y12_520y12);
sslauto.
ssl_close 2;
exists (vx22), (([:: vy122]) ++ (s1y12)), (wx22), (h_dll_wx22x2vy122s1y12_5231);
sslauto.
shelve.
ssl_close 2;
exists (vy122), (([:: vx22]) ++ (s1y12)), (y12), (y12 :-> vx22 \+ y12 .+ 1 :-> wy122 \+ y12 .+ 2 :-> y2 \+ h_dll_wy122y12s1y12_520y12);
sslauto.
shelve.
Unshelve.
shelve.
ssl_close 2;
exists (vx22), (s1y12), (wy122), (h_dll_wy122y12s1y12_520y12);
sslauto.
shelve.
Unshelve.
ssl_frame_unfold.
ssl_frame_unfold.
Qed.