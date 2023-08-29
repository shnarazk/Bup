#!/usr/bin/env cbqn

LinesOfCode ⇐ {𝕊 filename :
  +´{
    ∧´'#'≠𝕩 ? ⟨⟩≢𝕩 ;
    cs ← 𝕩⊸⊐⌾⋈'#'
    es ← ⌊´𝕩⊐"'"""
    es<cs
  }∘(¬∘∊⟜" "⊸/)¨•file.Lines filename
}

{
  0<≠•args ?
    env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1↓↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝v}}
    util ← •Import "/util.bqn"∾˜ "." env.Var⌾⋈ "BQN_LIB"
    util.Debug⟜LinesOfCode¨•args ;
  0
}
