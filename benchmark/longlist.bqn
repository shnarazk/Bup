#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1↓↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
util ← •Import "/util.bqn"∾˜∾env.Var⋈"BQN_LIB"

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

"init/add" util.Debug start_length‿updates ← 1e6‿1e4

!⟜(start_length⊸≡) ≠l ← start_length↑π
"update lst" util.Debug {{c‿m : l ↩ l∾π ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿⟨⟩}•_timed updates
l ↩ start_length↑π
"in-place -" util.Debug {{c‿m : l ∾⟜π ↩ ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿⟨⟩}•_timed updates
l ↩ start_length↑π
"update arg" util.Debug {l ↩ 1⊑{c‿l : l ↩ l∾π ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l} •_timed updates
l ↩ start_length↑π
"in-place -" util.Debug {l ↩ 1⊑{c‿l : l ∾⟜π ↩ ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l} •_timed updates
l ↩ start_length↑π
"in-place 2" util.Debug {l ↩ 1⊑{c‿l : ⟨c+1,l∾π⟩}•_while_(𝕩>⊑)0‿l} •_timed updates

m ← Longlist 100000
{m.Add π ⋄ 𝕩+1}•_while_(start_length⊸>)0
!⟜(start_length⊸≡) m.Size@
"indirect -" util.Debug {m ↩ 1⊑{c‿m : m.Add π ⋄ ⟨c+1,m⟩}•_while_(𝕩>⊑)0‿m} •_timed updates

!⟜((start_length+updates)⊸≡) ≠l
!⟜((start_length+updates)⊸≡) m.Size@

#  - init/add:   ⟨ 1000000 10000 ⟩
#  - update lst: 6.625975
#  - in-place -: 0.001391
#  - update arg: 6.722821000000001
#  - in-place -: 6.660316000000001
#  - in-place 2: 6.640160000000001
#  - indirect -: 0.0028940000000000003

