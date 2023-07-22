#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
⟨Debug⟩ ← •Import"/util.bqn"∾˜∾env.Var⋈"BQN_LIB"

# key:string-to-value:string base
•MakeRand •Unixtime
MkDict ← {
  breaks ← ¯1↓+`⌊´˘∘‿2⥊4+(4×𝕩)•rand.Range 10
  slen ← 4+¯1⊑breaks
  mask ← +`(<⁼∊⟜breaks)¨↕slen
  dic ← ∘‿2⥊mask⊔@+65+slen •rand.Range 26
  "failed to count"!𝕩=≠dic
  dic
}
# inject values to fields with @
Inject ← {@≡𝕩 ? 𝕨 ; 𝕩}¨

try‿qsize ← 100000‿1000

{
  env←{
    vars ⇐ ⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"
    Var ⇐ {⊐⟜𝕩⊸⊏⟜(∾⟜@)˝vars}
    Overwrite ⇐ {vars ← 𝕩}
  }
  "Retreive a value"    !"nash"≡∾env.Var⋈"USER"
  "Inject default vulue"!"π"   ≡∾(⋈"π") Inject env.Var⋈"∞"
  env.Overwrite 2‿∘⥊MkDict try
  defs ← ⥊MkDict qsize
  "Inject∘key⊐name≍val(msec)" Debug 1000×1000 (Defs⊸Inject⟜env.Var)•_timed ⥊MkDict qsize
}

{
  env ← {
    vars ⇐ ⥊⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"
    Map ⇐ {(𝕩≠⊸⥊@)𝕊𝕩 ; 𝕨{d 𝕊 ⟨k‿v⟩: v ; d 𝕊 s: d}¨(</⟜vars˜)˘𝕩{≡⟜⊑}⌜vars}
    Overwrite ⇐ {vars ← 𝕩}
  }
  "Retreive a value"    !"nash"≡∾env.Map⋈"USER"
  "Inject default vulue"!"π"   ≡∾"π" env.Map○⋈"∞"
  env.Overwrite <˘MkDict try
  "key=⌜name‿val      (msec)" Debug 1000× 100 env.Map•_timed ⥊MkDict qsize
}
