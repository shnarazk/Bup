# Since BQN uses immutable data structures, making long lists
# by adding elements repeately is compeletely impractical.
# If you have to build such a list, you should use multi-level addressing storage
# building from an index-vector and segments.

# This implementation does not support:
# - remove elements
# - modify elements
# but still works well on AoC y2018 day18.
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
  # storage lognLint 100000
  # storage.Add¨ 1‿3‿5
  # "dump" util.Debug storage.vec
  # "get" util.Debug storage.Get¨ 0‿2‿1
  # "tail" util.Debug storage.Tail 2
  # "size" util.Debug storage.Size@
