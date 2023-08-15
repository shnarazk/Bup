⟨
  dir5, dir9
  Ext,Shift,Rotate,Gather5,Gather9
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
Ext ← {
  𝕊 𝕩 : 0 𝕊 𝕩 ;
  fill 𝕊 x : (1⊸⌽fill⊸»⍟2)⎉1{𝔽 _𝕣 𝕩 : 𝔽⌾⍉𝔽 𝕩}(2+≢)⊸↑x ; 𝕊⁼𝕩 : (¯2+≢)⊸↑1⌽⎉1 1⌽𝕩
}

# Left(positive)/Right(negative) ShiftR1 a list (rank-1 array) contents *a* step, filling with ∞
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    ¯1‿∞ geo.ShiftR1 ↕10
# ⟨ 1 2 3 4 5 6 7 8 9 ∞ ⟩
#    1‿¯∞ geo.ShiftR1 ↕10
# ⟨ ∞ 0 1 2 3 4 5 6 7 8 ⟩
#    0‿0 geo.ShiftR1 ↕10
# ⟨ 0 1 2 3 4 5 6 7 8 9 ⟩
# ShiftR1 ← (1+×∘⊣)◶⟨«,⊢,»⟩
# ShiftR1∞ ← (1+×∘⊣)◶⟨∞⊸«,⊢,∞⊸»⟩
Shift1 ← {
  d‿f 𝕊 v : (1+×d)◶⟨f⊸«,⊢,f⊸»⟩v ;
  d 𝕊 v : (1+×d)◶⟨«,⊢,»⟩v
}

# Shift a matrix (rank-2 array)
#    g ← •Import "geometry.bqn"
# {dir5‿dir9‿ext‿shift‿rotate‿gather5‿gather9‿version⇐}
#    m ← 5‿5⥊↕25
# ┌─
# ╵  0  1  2  3  4
#    5  6  7  8  9
#   10 11 12 13 14
#   15 16 17 18 19
#   20 21 22 23 24
#                  ┘
#    1‿0‿∞ g.Shift∞ m
# ┌─
# ╵  ∞  ∞  ∞  ∞  ∞
#    0  1  2  3  4
#    5  6  7  8  9
#   10 11 12 13 14
#   15 16 17 18 19
#                  ┘
#    1‿2‿¯∞ g.Shift∞ m
# ┌─
# ╵ ∞ ∞  ∞  ∞  ∞
#   ∞ ∞  0  1  2
#   ∞ ∞  5  6  7
#   ∞ ∞ 10 11 12
#   ∞ ∞ 15 16 17
#                ┘
Shift  ← {
  y‿x   𝕊 a : >{(×y)⊸Shift⍟y⎉1⌾⍉(×x)⊸Shift⍟x⎉1 𝕩}¨<a ;
  y‿x‿f 𝕊 a : >{⟨×y,f⟩⊸Shift⍟y⎉1⌾⍉⟨×x,f⟩⊸Shift⍟x⎉1 𝕩}¨<a
}
# Shift∞ ← {y‿x 𝕊 a : >{(×y)⊸ShiftR1∞⍟y⎉1⌾⍉(×x)⊸ShiftR1∞⍟x⎉1 𝕩}¨<a}

# Rotate a matrix (rank-2 array)
# Note: rotation direction is along with dyadic `⌽`; 1‿1 is rotating to up‿left
#    g ← •Import "geometry.bqn"
# {dir5‿dir9‿ext‿shift‿rotate‿gather5‿gather9‿version⇐}
#    m ← 5‿5⥊↕25
# ┌─
# ╵  0  1  2  3  4
#    5  6  7  8  9
#   10 11 12 13 14
#   15 16 17 18 19
#   20 21 22 23 24
#                  ┘
#    1‿0 g.Rotate m
# ┌─
# ╵  5  6  7  8  9
#   10 11 12 13 14
#   15 16 17 18 19
#   20 21 22 23 24
#    0  1  2  3  4
#                  ┘
#    1‿2 g.Rotate m
# ┌─
# ╵  7  8  9  5  6
#   12 13 14 10 11
#   17 18 19 15 16
#   22 23 24 20 21
#    2  3  4  0  1
#                  ┘
Rotate ← {y‿x 𝕊 a : >{y⊸⌽⎉1⌾⍉x⊸⌽⎉1 𝕩}¨<a}

# Gather self and four neighbars as a list and invalid neighbars are prsented by 'fill'
#    geo ← •Import "geometric.bqn"
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    m ← 3‿3⥊↕9
# ┌─
# ╵ 0 1 2
#   3 4 5
#   6 7 8
#         ┘
#    ∞ geo.Gather5 m
# ┌─
# ╵ ⟨ 0 ∞ 3 ∞ 1 ⟩ ⟨ 1 ∞ 4 0 2 ⟩ ⟨ 2 ∞ 5 1 ∞ ⟩
#   ⟨ 3 0 6 ∞ 4 ⟩ ⟨ 4 1 7 3 5 ⟩ ⟨ 5 2 8 4 ∞ ⟩
#   ⟨ 6 3 ∞ ∞ 7 ⟩ ⟨ 7 4 ∞ 6 8 ⟩ ⟨ 8 5 ∞ 7 ∞ ⟩
#                                             ┘
Gather5 ← {
    𝕊 m : {∾¨´dir5 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext m ;
  f 𝕊 m : {∾¨´dir5 Shift{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext m
}
# Gather5∞ ← {∾¨´dir5 ShiftR1∞{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

# Gather self and eight neighbars as a list and invalid neighbars are prsented by 'fill'
Gather9 ← {
    𝕊 m : {∾¨´dir9 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext m ;
  f 𝕊 m : {∾¨´dir9 Shift{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext m}
# Gather9∞ ← {∾¨´dir9 ShiftR1∞{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

version ⇐ "0.3.0"
