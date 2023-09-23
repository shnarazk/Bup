#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1↓↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
util ← •Import "/util.bqn"∾˜∾env.Var⋈"BQN_LIB"

# Since BQN uses immutable data structures, in-place updating
# is crucial. But it's not impossible in some case.
# A solution is passing namespace intead of passing object itself
# as an argument.
LongList ⇐ {
    chunk ← 𝕩
    vec ⇐ ⟨⟨⟩⟩
    Get ⇐ {𝕊 𝕩 : c ← 𝕩⌊∘÷chunk ⋄ (chunk|𝕩)⊑c⊑vec}
    Add ⇐ { chunk=≠¯1⊑vec ? vec ∾⟜⟨𝕩⟩ ↩ ; vec ∾⟜𝕩⌾(¯1⊸⊑) ↩ }
    Size ⇐ {𝕤 ⋄ +´≠¨vec}
    Tail ⇐ {
      𝕊 n : n≤Size@ ? (-n){ (-𝕨)≤≠𝕩 ? 𝕨↑𝕩 ; 𝕨↑∾⟜𝕩 ¯2⊑vec}¯1⊑vec ;
      𝕊 n : ∾vec
    }
  }

util.Debug start_length ← 1e6
amount ← 1e5
l ← start_length↑π
ll ← Longlist 100000
{ll.Add π ⋄ 𝕩+1}•_while_(start_length⊸>)0
!⟜(start_length⊸≡) ≠l
!⟜(start_length⊸≡) ll.Size@

repeat ← 1
"list"     util.Debug repeat {{l ↩ l∾π ⋄ 𝕩+1}•_while_(𝕩⊸>)0}•_timed amount
"in-place update" util.Debug repeat {{l  ∾⟜π ↩⋄ 𝕩+1}•_while_(𝕩⊸>)0}•_timed amount
"list argument" util.Debug repeat {{c‿l : l ↩ l∾π ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l}•_timed amount
"in-place argument" util.Debug repeat {{c‿l : l ∾⟜π ↩ ⋄ ⟨c+1,l⟩}•_while_(𝕩>⊑)0‿l}•_timed amount
"longlist" util.Debug repeat {{ll.Add π ⋄ 𝕩+1}•_while_(𝕩⊸>)0}•_timed amount
!⟜((start_length+repeat×amount)⊸≡) ≠l
!⟜((start_length+repeat×amount)⊸≡) ll.Size@
util.Debug "done"
