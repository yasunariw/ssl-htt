From mathcomp
Require Import ssreflect ssrbool ssrnat eqtype seq ssrfun.
From fcsl
Require Import prelude pred pcm unionmap heap.
From HTT
Require Import stmod stsep stlog stlogR.
From SSL
Require Import core.

Definition swap_type :=
  forall (vprogs : ptr * ptr),
  {(vghosts : ptr * ptr)},
  STsep (
    fun h =>
      let: (x, y) := vprogs in
      let: (a, b) := vghosts in
      h = x :-> a \+ y :-> b,
    [vfun (_: unit) h =>
      let: (x, y) := vprogs in
      let: (a, b) := vghosts in
      h = x :-> b \+ y :-> a
    ]).

Program Definition swap : swap_type :=
  Fix (fun (swap : swap_type) vprogs =>
    let: (x, y) := vprogs in
    Do (
      a2 <-- @read ptr x;
      b2 <-- @read ptr y;
      x ::= b2;;
      y ::= a2;;
      ret tt
    )).
Obligation Tactic := intro; move=>[x y]; ssl_program_simpl.
Next Obligation.
ssl_ghostelim_pre.
move=>[a b].
move=>[sigma_self].
subst h_self.
ssl_ghostelim_post.
ssl_read x.
try rename a into a2.
ssl_read y.
try rename b into b2.
ssl_write x.
ssl_write_post x.
ssl_write y.
ssl_write_post y.
ssl_emp;
sslauto.
Qed.