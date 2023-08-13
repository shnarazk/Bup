⟨
  dir5, dir9
  Ext,Shift,Gather5,Gather9
  version
⟩ ⇐

dir5 ← ⟨0‿0,1‿0,¯1‿0,0‿1,0‿¯1⟩
dir9 ← ¯1+⥊↕3‿3

# Extend a 2D matrix with 1-width borders which are ∞
#    geo ← •Import "geometric.bqn"
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    geo.Ext ↕3‿3
# ┌─
# ╵ ∞ ∞       ∞       ∞       ∞
#   ∞ ⟨ 0 0 ⟩ ⟨ 0 1 ⟩ ⟨ 0 2 ⟩ ∞
#   ∞ ⟨ 1 0 ⟩ ⟨ 1 1 ⟩ ⟨ 1 2 ⟩ ∞
#   ∞ ⟨ 2 0 ⟩ ⟨ 2 1 ⟩ ⟨ 2 2 ⟩ ∞
#   ∞ ∞       ∞       ∞       ∞
#                               ┘
#    geo.Ext⁼ geo.Ext ↕3‿3
# ┌─
# ╵ ⟨ 0 0 ⟩ ⟨ 0 1 ⟩ ⟨ 0 2 ⟩
#   ⟨ 1 0 ⟩ ⟨ 1 1 ⟩ ⟨ 1 2 ⟩
#   ⟨ 2 0 ⟩ ⟨ 2 1 ⟩ ⟨ 2 2 ⟩
#                           ┘
Ext ← {𝕊 x : (1⊸⌽∞⊸»⍟2)⎉1{𝔽 _𝕣 𝕩 : 𝔽⌾⍉𝔽 𝕩}(2+≢)⊸↑x ; 𝕊⁼𝕩 : (¯2+≢)⊸↑1⌽⎉1 1⌽𝕩}

# Left(positive)/Right(negative) Shift a list contents a step, filling with ∞
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    ¯1 geo.Shift ↕10
# ⟨ 1 2 3 4 5 6 7 8 9 ∞ ⟩
#    1 geo.Shift ↕10
# ⟨ ∞ 0 1 2 3 4 5 6 7 8 ⟩
#    0 geo.Shift ↕10
# ⟨ 0 1 2 3 4 5 6 7 8 9 ⟩
Shift ← (1+×∘⊣)◶⟨∞⊸«,⊢,∞⊸»⟩

# Gather self and four neighbars as a list
#    geo ← •Import "geometric.bqn"
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    m ← 3‿3⥊↕9
# ┌─
# ╵ 0 1 2
#   3 4 5
#   6 7 8
#         ┘
#    geo.Gather5 m
# ┌─
# ╵ ⟨ 0 ∞ 3 ∞ 1 ⟩ ⟨ 1 ∞ 4 0 2 ⟩ ⟨ 2 ∞ 5 1 ∞ ⟩
#   ⟨ 3 0 6 ∞ 4 ⟩ ⟨ 4 1 7 3 5 ⟩ ⟨ 5 2 8 4 ∞ ⟩
#   ⟨ 6 3 ∞ ∞ 7 ⟩ ⟨ 7 4 ∞ 6 8 ⟩ ⟨ 8 5 ∞ 7 ∞ ⟩
#                                             ┘
Gather5 ← {∾¨´dir5 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

# Gather self and eight neighbars as a list
Gather9 ← {∾¨´dir9 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

version ⇐ "0.1,0"