⟨AsString,IsString,LeftFill,AsFixedFloat⟩ ⇐

AsString ← {0=•Type 𝕩 ? 1==𝕩 ? ∧´(2=•Type)¨𝕩 ? 𝕩 ; •Repr 𝕩}

IsString ← {0=•Type 𝕩 ? ⟨⟩≢𝕩 ? ∧´(2=•Type)¨𝕩 ; 0}
# "IsString spec1"! IsString "1"
# "IsString spec2"!¬IsString ""
# "IsString spec3"!¬IsString ⟨⟩
# "IsString spec4"!¬IsString 0
# "IsString spec5"!¬IsString ⟨0⟩

LeftFill ← {
  template 𝕊 value : IsString value ? value∾˜(0⌈template-○≠value)↑template ;
  𝕨 𝕊 (•Repr 𝕩)
}
# "LeftFill spec1"! "   1"≡"    " LeftFill "1"
# "LeftFill spec2"! "..10"≡"...." LeftFill "10"
# "LeftFill spec3"! "1000"≡"    " LeftFill "1000"
# "LeftFill spec4"!"10000"≡"    " LeftFill "10000"
# "LeftFill spec5"! " 100"≡"    " LeftFill 100
# "LeftFill spec6"! "  ⟨⟩"≡"    " LeftFill ⟨⟩
# "LeftFill spec7"! " ⟨1⟩"≡"    " LeftFill ⟨1⟩
# "LeftFill spec8"! " 0‿1"≡"    " LeftFill ↕2

AsFixedFloat ← {
    𝕊 𝕩 : 3 𝕊 𝕩 ;
  d 𝕊 𝕩 :
    pad ← '0'+d↑0
  z ← (¯1+≠s)-(s ← •Repr(⌊0.5⊸+)⌾((10⋆d)⊸×)𝕩)⊸⊐⌾⋈'.'
  {
    ¯1=z ? s∾'.'∾pad ;
     d>z ? s∾(d-z)↑pad ;
    s
  }
}
