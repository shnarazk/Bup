#
# O(log(N)) heap constructed from order function: version 0.2.0
#
# Note
# A heap is created from a comparing _dyadic_ function.
# So if, for example, you want to compare the first elements, use `Over` like:
#
#  H ← (≤○⊑)_to_heap
#
# You can write as follow, but this is more expensive to compare all elements:
#
#  H ← (⊑≤)_to_heap
#
# And you will get a rank error by:
#
#  H ← (≤⊑)_to_heap
#

Parent ← 2⌊∘÷˜¯1⊸+
Children ← ¯1‿0+2×1⊸+

_to_heap ⇐ {𝔽_𝕣 :
  l ← ⟨⟩
  Ord ← 𝔽
  Dump ⇐ {𝕤 ⋄ l}
  Push ⇐ {k ← ≠l ⋄ l ∾⟜⟨𝕩⟩ ↩ ⋄ ShiftUp k}
  ShiftUp ← {
    {𝕊 n :
      Ord´ c‿p ← ⟨n⊑l,(m ← Parent n)⊑l⟩ ?
      # l (p⌾(n⊸⊑)c⌾(m⊸⊑)) ↩
      l ⌽⌾(n‿m⊸⊏) ↩
      m ;
      0
    }•_while_(0⊸<)𝕩
  }
  Empty ⇐ {𝕤 ⋄ 0=≠l}
  Peek ⇐ {𝕤 ⋄ ⊑l}
  Pop ⇐ {𝕤 ⋄ n ← ¯1+≠l ⋄ v‿u ← ⟨⊑l,n⊑l⟩ ⋄ l u⌾⊑ ↩ ⋄ ShiftDown 0 ⋄ l n⊸↑ ↩ ⋄ v}
  ShiftDown ← {𝕊 m :
    len ← ≠l
    {𝕊 m :
      n1‿n2 ← Children m
      {
        len≤n1 ? len ;
        n ← {len=1+n1 ? n1 ; (Ord´n1‿n2⊏l)◶⟨n2,n1⟩@}
        # This two phase update is much faster than `l ⌽⌾(n‿m⊸⊏) ↩`
        x‿y ← ⟨n⊑l,m⊑l⟩
        l (y⌾(n⊸⊑)x⌾(m⊸⊑)) ↩
        n
      }
    }•_while_(len⊸>)m
  }
}
