⟨
  If,IfElse,_doWhile_,Match,Select,Switch,Test,
  Swap,
  Tokenize,StartsWith,ParseInt,ParseInts,ParseFloats,color,term,
  Debug,Progress,
  MaxAt,MinAt,
  AbsolutePath,DataFile,
  version
⟩ ⇐

#
# program structure
#
If      ← {𝕏⍟𝕎@}´                 # Also Repeat
IfElse  ← {c‿T‿F : c◶F‿T@}
_doWhile_ ← {𝔾@ ⋄ 𝔽 •_while_ 𝔾}
# For     ← {I‿C‿P‿A : I@ ⋄ (P∘A)•_while_ C}
Match   ← {𝕏𝕨}´
Select  ← {(⊑𝕩)◶(1↓𝕩)@}
Switch  ← {c←⊑𝕩 ⋄ m‿a←<˘⍉∘‿2⥊1↓𝕩 ⋄ (m⊸⊐⌾<C)◶a@}
Test    ← {fn←{C‿A𝕊e : C◶A‿E}´𝕩 ⋄ Fn@}

#
# list operations
#
#     Swap list: swap the first element and the second one of the `list`
# i‿j Swap list: swap the `i`-th element and the `j`-th one of the `list`
Swap ← {0‿1 𝕊 𝕩 ; ⋈˜´⌾(𝕨⊸⊏)𝕩}

Partition ← {w 𝕊 x : x⊔˜-¬({+`1∾<´˘2↕𝕩}×¬)x∊w}
# "Partition spec1" ! ⟨"A","BC","D","E"⟩  ≡ "x,z" Partition "xA,BCzzDx,zEx"
# "Partition spec2" ! ⟨"AB","C","DE"⟩     ≡   " " Partition "AB C  DE"
# "Partition spec3" ! ⟨⟨¯3,¯2⟩,⟨0⟩,⟨2,3⟩⟩ ≡  ¯1‿1 Partition ¯3+↕7

#
# string operations
#
StartsWith  ← ⊢≡↑˜⟜≠
ParseFloats ← •ParseFloat¨·(∨´"0123456789"⊸∊)¨⊸/"0123456789.-"⊸((⊢-˜¬×·+`»⊸<)∘(¬∊)˜⊔⊢)
ParseInts   ← ⌊∘•ParseFloat¨·(∨´"0123456789"⊸∊)¨⊸/"0123456789-"⊸((⊢-˜¬×·+`»⊸<)∘(¬∊)˜⊔⊢)
ParseInt    ← ⊑ParseInts

Tokenize ← {" " 𝕊 𝕩 ; (𝕩¬∘∊𝕨)(¬-˜⊢×·+`»⊸>)⊸⊔𝕩}
# "Tokenize spec1" ! ⟨"A","B,C,","D"⟩  ≡  " " Tokenize "A B,C, D"
# "Tokenize spec2" ! ⟨"A","B","C","D"⟩ ≡ " ," Tokenize "A B,C, D"

color ← {
  # https://en.wikipedia.org/wiki/ANSI_escape_code
  esc     ⇐ @+27
  csi     ⇐ esc∾"["
  black   ⇐ csi∾"30m"
  red     ⇐ csi∾"31m"
  green   ⇐ csi∾"32m"
  yellow  ⇐ csi∾"33m"
  blue    ⇐ csi∾"34m"
  magenta ⇐ csi∾"35m"
  cyan    ⇐ csi∾"36m"
  white   ⇐ csi∾"37m"
  reverse ⇐ csi∾"001m"
  reset   ⇐ csi∾"0m"
  RGB ⇐ {
          𝕊 r‿g‿b : esc∾"[38;2;"∾(•Fmt r)∾";"∾(•Fmt g)∾";"∾(•Fmt b)∾"m" ;
        0 𝕊 r‿g‿b : esc∾"[38;2;"∾(•Fmt r)∾";"∾(•Fmt g)∾";"∾(•Fmt b)∾"m" ;
    r‿g‿b 𝕊 0     : esc∾"[48;2;"∾(•Fmt r)∾";"∾(•Fmt g)∾";"∾(•Fmt b)∾"m" ;
       bg 𝕊 fg    : (bg 𝕊 0)∾𝕊 fg
  }
  Out ⇐ {c 𝕊 t : c∾t∾reset}
  Fmt ⇐ {c 𝕊 t : c∾(•Fmt t)∾reset}
}
term ← {
  # https://en.wikipedia.org/wiki/ANSI_escape_code
  lf ⇐ @ + 10
  cr ⇐ @ + 13
  esc ⇐ @ + 27
  csi ⇐ esc∾"["
  reverse ⇐ csi∾"001m"
  reset ⇐ csi∾"0m"
  Revert ⇐ {•term.OutRaw•ToUTF8 csi∾(•Fmt 𝕩)∾"A"∾csi∾"1G"∾csi∾"0J"}
  Up ⇐ {
    •term.OutRaw•ToUTF8 csi∾(•Fmt 𝕩)∾"A" ;
    csi∾(•Fmt 𝕩)∾"A"
  }
  clear ⇐ csi∾"1G"∾csi∾"0J"
  Print ⇐ {
    •term.OutRaw•ToUTF8 •Fmt 𝕩 ;
    •term.OutRaw•ToUTF8 𝕨∾(•Fmt 𝕩)∾reset
  }
  Println ⇐ {
    •Out •Fmt 𝕩 ;
    •Out 𝕨∾(•Fmt 𝕩)∾reset
  }
  Out ⇐ {
    •term.OutRaw•ToUTF8 𝕩∾reset ;
    •term.OutRaw•ToUTF8 𝕨∾𝕩∾reset
  }
  OutLn ⇐ {
    •Out 𝕩 ;
    •Out 𝕨∾𝕩∾reset
  }
}

Debug ← {
     𝕊 𝕩 : "debug" 𝕊 𝕩 ;
  ⟨⟩ 𝕊 𝕩 : 𝕩 ;
   𝕨 𝕊 𝕩 :
    label ← (220‿220‿220 color.RGB 180‿80‿80)
    text  ← color.RGB 20‿100‿200
    label term.Outln " - "∾𝕨∾":"∾(' '˙¨↕8-8|5+≠𝕨)∾text color.Fmt 𝕩
    𝕩
}

# 𝕨 should be a number
# - 0 for displaying without pause
# - ⟨⟩ or @ for returning 𝕩 without display
# - n for displaying 𝕩 for n mili sec.
# - ∞ for displaying without overwriting
Progress ← {
  𝕊 𝕩      : 0 𝕊 𝕩 ;
  0 𝕊 𝕩    :
    textc ← color.RGB 20‿100‿200
    len ← +´term.lf= text ← {0=•Type 𝕩 ? 1==𝕩 ? ∧´(2=•Type)¨𝕩 ? 𝕩 ; •Fmt 𝕩}𝕩
    textc term.OutLn text
    term.Out term.csi∾(•Fmt 1+len)∾"A"∾term.clear
    𝕩 ;
  @ 𝕊 𝕩    : 𝕩 ;
  ⟨⟩ 𝕊 𝕩   : 𝕩 ;
  spec 𝕊 𝕩 :
    label ← (220‿220‿220 color.RGB 180‿80‿80)
    textc ← color.RGB 20‿100‿200
    len ← +´term.lf= text ← {0=•Type 𝕩 ? 1==𝕩 ? ∧´(2=•Type)¨𝕩 ? 𝕩 ; •Fmt 𝕩}𝕩
    {
      1=•Type spec ?
        textc term.OutLn text
        {0<spec ? ∞>spec ? •Delay spec ; @} ;
      1==spec ? ∧´(2=•Type)¨spec ?
        label term.OutLn spec∾":"∾(' '˙¨↕8-8|5+≠spec)∾textc color.Out text ;
      "invalid 𝕨 for Progress"!0
    }
    {∞>spec ? term.Out term.csi∾(•Fmt 1+len)∾"A"∾term.clear ; @}
    𝕩
}

#
# math functions
#
# This does not work with depth≥2
# TODO: as ⊑∧⌾(𝕨⊏)¨
MaxAt ← {n F l : {𝕨>○(n⊸⊑)𝕩 ? 𝕨 ; 𝕩}´l}
MinAt ← {n F l : {𝕨<○(n⊸⊑)𝕩 ? 𝕨 ; 𝕩}´l}

#
# file operations
#
AbsolutePath ← {'/'=⊑𝕩 ? 𝕩 ; •wdpath∾"/"∾𝕩}
DataFile ← AbsolutePath∘{0<≠𝕩 ? ⊑𝕩 ; 𝕨}

env←{
  vars ⇐ ⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"
  Var ⇐ {@𝕊𝕩 ; ⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝vars}
  Map ⇐ {@≡𝕩 ? 𝕨 ; 𝕩}¨⟜(@⊸Var)
}
# "env.Var takes default"  ! ".∞."    ≡ ".∞."      env.Var⌾⋈ "NOT_DEF"
# "env.Map takes default"  ! ".∞."    ≡ ".∞."    ∾∘env.Map○⋈ "NOT_DEF"
# "env.Map takes defaults" ! "¯∞"‿"∞" ≡ "¯∞"‿"∞" ∾∘env.Map○⋈ "NOT_DEF1"‿"NOT_DEF2"

version ← "0.7.3"
