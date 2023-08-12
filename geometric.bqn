⟨
  dir5, dir9
  Ext,Shift,Gather5,Gather9
  version
⟩ ⇐

dir5 ← ⟨0‿0,1‿0,¯1‿0,0‿1,0‿¯1⟩
dir9 ← (¯1+↕3‿3)

# Extend a 2D matrix with 1-width borders which are ∞
Ext ← {𝕊 x : (1⊸⌽∞⊸»⍟2)⎉1{𝔽 _𝕣 𝕩 : 𝔽⌾⍉𝔽 𝕩}(2+≢)⊸↑x ; 𝕊⁼𝕩 : (¯2+≢)⊸↑1⌽⎉1 1⌽𝕩}

# Left(positive)/Right(negative) Shift a list contents a step, filling with ∞
Shift ← (1+×∘⊣)◶⟨∞⊸«,⊢,∞⊸»⟩

# Gather self and four neighbars as a list
Gather5 ← {∾¨´dir5 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

# Gather self and eight neighbars as a list
Gather9 ← {∾¨´dir9 Shift{y‿x 𝔽 _𝕣 𝕩 : y⊸𝔽⎉1⌾⍉x⊸𝔽⎉1 𝕩}¨<𝕩}⌾Ext

version ⇐ "0.1,0"