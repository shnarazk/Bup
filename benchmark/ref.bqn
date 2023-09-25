#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1↓↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
util ← •Import "/util.bqn"∾˜env.Var⌾⋈"BQN_LIB"

# Since BQN uses immutable data structures, in-place updating
# is crucial. But it's not impossible in some case.
# A solution is passing namespace intead of passing object itself
# as an argument.
LongList ⇐ {
  segment ← 𝕩
  vec ⇐ ⟨⟨⟩⟩
  Get ⇐ {𝕊 𝕩 : c ← 𝕩⌊∘÷segment ⋄ (segment|𝕩)⊑c⊑vec}
  Add ⇐ { segment=≠¯1⊑vec ? vec ∾⟜⟨𝕩⟩ ↩ ; vec ∾⟜𝕩⌾(¯1⊸⊑) ↩ }
  Size ⇐ {𝕤 ⋄ +´≠¨vec}
  Tail ⇐ {
    𝕊 n : n≤Size@ ? (-n){ (-𝕨)≤≠𝕩 ? 𝕨↑𝕩 ; 𝕨↑∾⟜𝕩 ¯2⊑vec}¯1⊑vec ;
    𝕊 n : ∾vec
  }
}

Ref ⇐ {
  ref ⇐ 𝕩
  Set ⇐ {ref ↩ 𝕩 }
  Append ⇐ {ref ∾⟜𝕩 ↩ }
  Preppend ⇐ {ref 𝕩⊸∾ ↩ }
  Update1 ⇐ {f ← ⊑𝕩 ⋄ ref F ↩ }
  _update2 ⇐ {ref 𝔽 ↩ }
  _update3 ⇐ {ref 𝔽 ↩ 𝕩}
}

"init/add" util.Debug start_length‿updates ← 1e6‿1e4

!⟜(start_length⊸≡) ≠l ← start_length↑π
"update lst" util.Debug {{c‿m : l ↩ l∾π ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿⟨⟩}•_timed updates
!⟜((start_length+updates)⊸≡) ≠l
l ↩ start_length↑π
"in-place -" util.Debug {{c‿m : l ∾⟜π ↩ ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿⟨⟩}•_timed updates
!⟜((start_length+updates)⊸≡) ≠l
l ↩ start_length↑π
"update arg" util.Debug {l ↩ 1⊑{c‿l : l ↩ l∾π ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l
l ↩ start_length↑π
"in-place -" util.Debug {l ↩ 1⊑{c‿l : l ∾⟜π ↩ ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l
l ↩ start_length↑π
"in-place 2" util.Debug {l ↩ 1⊑{c‿l : ⟨c+1,l∾π⟩}•_while_(𝕩>⊑)0‿l} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l

l ↩ start_length↑π
"Ref.append" util.Debug {l ↩ {𝕩.ref}1⊑{c‿w : w.Append π ⋄ ⟨c+1,w⟩}•_while_(𝕩>⊑)⟨0,Ref l⟩} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l

l ↩ start_length↑π
"-.update1" util.Debug {l ↩ {𝕩.ref}1⊑{c‿w : w.Update1⟨∾⟜π⟩ ⋄ ⟨c+1,w⟩}•_while_(𝕩>⊑)⟨0,Ref l⟩} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l

l ↩ start_length↑π
"-._update2" util.Debug {l ↩ {𝕩.ref}1⊑{c‿w : ∾⟜π w._update2 @ ⋄ ⟨c+1,w⟩}•_while_(𝕩>⊑)⟨0,Ref l⟩} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l

l ↩ start_length↑π
"-._update3" util.Debug {l ↩ {𝕩.ref}1⊑{c‿w : ∾ w._update3 π ⋄ ⟨c+1,w⟩}•_while_(𝕩>⊑)⟨0,Ref l⟩} •_timed updates
!⟜((start_length+updates)⊸≡) ≠l

m ← Longlist 100000
{m.Add π ⋄ 𝕩+1}•_while_(start_length⊸>)0
!⟜(start_length⊸≡) m.Size@
"indirect -" util.Debug {m ↩ 1⊑{c‿m : m.Add π ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿m} •_timed updates
!⟜((start_length+updates)⊸≡) m.Size@

#  - update lst: 6.697469000000001
#  - in-place -: 0.0014390000000000002
#  - update arg: 6.643209000000001
#  - in-place -: 6.647899000000001
#  - in-place 2: 6.660026
#  - wrap in ns: 0.0029370000000000004
#  - indirect -: 0.002893

# $ cbqn benchmark/ref.bqn to add Ref._apply
#  - init/add:   ⟨ 1000000 10000 ⟩
#  - update lst: 2.484448
#  - in-place -: 0.00064
#  - update arg: 2.496944
#  - in-place -: 2.497812
#  - in-place 2: 2.493621
#  - Ref.append: 0.00117
#  - -.update1:  0.0014800000000000002
#  - -._update2: 0.0013770000000000002
#  - -._update3: 0.001108
#  - indirect -: 0.0015190000000000002
