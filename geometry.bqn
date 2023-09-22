⟨
  dir5, dir9
  Ext,Shift,Rotate,
  Neighbor4,Neighbor5,Neighbor8,Neighbor9
  version
⟩ ⇐

dir5 ← ⟨0‿0,1‿0,¯1‿0,0‿1,0‿¯1⟩
dir4 ← ⟨1‿0,¯1‿0,0‿1,0‿¯1⟩
dir9 ← -¯1+⥊↕3‿3
dir8 ← 0‿0⊸≢¨⊸/¯1+⥊↕3‿3

# Extend a 2D matrix with 1-width borders which are ∞
#    geo ← •Import "geometry.bqn"
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    ∞ geo.Ext ↕3‿3
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
  𝕊⁼𝕩 : (¯2+≢)⊸↑1⌽⎉1 1⌽𝕩 ;
  fill 𝕊 x : (1⊸⌽fill⊸»⍟2)⎉1{𝔽 _𝕣 𝕩 : 𝔽⌾⍉𝔽 𝕩}(2+≢)⊸↑x ;
  fill 𝕊⁼𝕩 : (¯2+≢)⊸↑1⌽⎉1 1⌽𝕩
}

# Left(positive)/Right(negative) ShiftR1 a list (rank-1 array) contents *a* step, filling with ∞
#    ¯1‿∞ Shift1 ↕10
# ⟨ 1 2 3 4 5 6 7 8 9 ∞ ⟩
#    1‿¯∞ Shift1 ↕10
# ⟨ ¯∞ 0 1 2 3 4 5 6 7 8 ⟩
#    0‿0 Shift1 ↕10
# ⟨ 0 1 2 3 4 5 6 7 8 9 ⟩
Shift1 ← {
  d‿f 𝕊 v : (1+×d)◶⟨f⊸«,⊢,f⊸»⟩v ;
  d   𝕊 v : (1+×d)◶⟨«,⊢,»⟩v
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
#    1‿0‿∞ g.Shift m
# ┌─
# ╵  ∞  ∞  ∞  ∞  ∞
#    0  1  2  3  4
#    5  6  7  8  9
#   10 11 12 13 14
#   15 16 17 18 19
#                  ┘
#    1‿2‿¯∞ g.Shift m
# ┌─
# ╵ ¯∞ ¯∞ ¯∞ ¯∞ ¯∞
#   ¯∞ ¯∞  0  1  2
#   ¯∞ ¯∞  5  6  7
#   ¯∞ ¯∞ 10 11 12
#   ¯∞ ¯∞ 15 16 17
#                  ┘
Shift  ← {
  y‿x   𝕊 a : >{  (×y)⊸Shift1⍟y⎉1⌾⍉  (×x)⊸Shift1⍟x⎉1 𝕩}¨<a ;
  y‿x‿f 𝕊 a : >{⟨×y,f⟩⊸Shift1⍟y⎉1⌾⍉⟨×x,f⟩⊸Shift1⍟x⎉1 𝕩}¨<a
}

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

# Neighbor self and four neighbars as a list and invalid neighbars are prsented by 'fill'
# they are ordered as self up down left right
#    geo ← •Import "geometry.bqn"
# {dir5‿dir9‿ext‿shift‿gather5‿gather9‿version⇐}
#    m ← 3‿3⥊↕9
# ┌─
# ╵ 0 1 2
#   3 4 5
#   6 7 8
#         ┘
#    ∞ geo.Neighbor5 m
# ┌─
# ╵ ⟨ 0 ∞ 3 ∞ 1 ⟩ ⟨ 1 ∞ 4 0 2 ⟩ ⟨ 2 ∞ 5 1 ∞ ⟩
#   ⟨ 3 0 6 ∞ 4 ⟩ ⟨ 4 1 7 3 5 ⟩ ⟨ 5 2 8 4 ∞ ⟩
#   ⟨ 6 3 ∞ ∞ 7 ⟩ ⟨ 7 4 ∞ 6 8 ⟩ ⟨ 8 5 ∞ 7 ∞ ⟩
#                                             ┘
Neighbor5 ← {
    𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir5 Shift1{y‿x 𝔽 _𝕣 𝕩 :   y⊸𝔽⎉1⌾⍉  x⊸𝔽⎉1 𝕩}¨<𝕩} m ;
  f 𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir5 Shift1{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩} m
}
Neighbor4 ← {
    𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir4 Shift1{y‿x 𝔽 _𝕣 𝕩 :   y⊸𝔽⎉1⌾⍉  x⊸𝔽⎉1 𝕩}¨<𝕩} m ;
  f 𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir4 Shift1{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩} m
}

# Neighbor self and eight neighbars as a list and invalid neighbars are prsented by 'fill'
# they are ordered as ¯1+⥊↕3‿3. So the center is the 5th item.
#    g ← •Import "geometry.bqn"
# {dir5‿dir9‿ext‿shift‿rotate‿gather5‿gather9‿version⇐}
#    m ← 3‿3⥊↕9
# ┌─
# ╵ 0 1 2
#   3 4 5
#   6 7 8
#         ┘
#    ∞ g.Neighbor9 m
# ┌─
# ╵ ⟨ ∞ ∞ ∞ ∞ 0 1 ∞ 3 4 ⟩ ⟨ ∞ ∞ ∞ 0 1 2 3 4 5 ⟩ ⟨ ∞ ∞ ∞ 1 2 ∞ 4 5 ∞ ⟩
#   ⟨ ∞ 0 1 ∞ 3 4 ∞ 6 7 ⟩ ⟨ 0 1 2 3 4 5 6 7 8 ⟩ ⟨ 1 2 ∞ 4 5 ∞ 7 8 ∞ ⟩
#   ⟨ ∞ 3 4 ∞ 6 7 ∞ ∞ ∞ ⟩ ⟨ 3 4 5 6 7 8 ∞ ∞ ∞ ⟩ ⟨ 4 5 ∞ 7 8 ∞ ∞ ∞ ∞ ⟩
#                                                                     ┘
Neighbor9 ← {
    𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir9 Shift1{y‿x 𝔽 _𝕣 𝕩 :   y⊸𝔽⎉1⌾⍉  x⊸𝔽⎉1 𝕩}¨<𝕩}m ;
  f 𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir9 Shift1{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩}m
}
Neighbor8 ← {
    𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir8 Shift1{y‿x 𝔽 _𝕣 𝕩 :   y⊸𝔽⎉1⌾⍉  x⊸𝔽⎉1 𝕩}¨<𝕩}m ;
  f 𝕊 m : {(⟨⟩¨𝕩)<⊸∾¨´dir8 Shift1{y‿x 𝔽 _𝕣 𝕩 : y‿f⊸𝔽⎉1⌾⍉x‿f⊸𝔽⎉1 𝕩}¨<𝕩}m
}

version ⇐ "0.5.0"
