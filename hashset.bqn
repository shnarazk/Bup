# HashSet based on https://github.com/mlochbaum/bqn-libs/blob/master/hashmap.bqn
# HashSet keys:      return a mutable hashset h implementing
#   h.Count any:     return number of keys defined by h
#   h.Has key:       return 1 if key is present and 0 otherwise
#   h.Set key:       set value (may overwrite); return h
#   h.Delete key:    remove corresponding value; return h
#   h.copy any:      return a new hashset with same keys

# 𝕗_hash is a function returning index in (2⋆n)-length table
⟨_hash⟩ ← {
  base ← 2 ⋆ b←32
  _hash ⇐ { bits _𝕣:
    ! 1≤bits
    d‿m←b(⌈∘÷˜⋈|)bits
    mod ← (0<m)⊑⟨⊢,(2⋆m)⊸|⟩
    acc ← (2⌊d-1)⊑⟨Mod⊑, (base×Mod∘⊑)+¯1⊸⊑, +⟜(base⊸×)´·⌽Mod⌾⊑∘↑⟩
    (-d) Acc •Hash
  }
}

HashSet ⇐ {𝕩.Self𝕩}∘{ 𝕊 keys: Self⇐{self↩𝕩}
  "HashSet: keys 𝕩 must be arrays" ! 0=•Type keys
  keys ⥊↩
  hlen←bits←table←0 ⋄ Ind←Next←⊢
  InitSize ← {
    hlen ↩ 2 ⋆ bits ↩ 1+⌈2⋆⁼ 1⌈𝕩  # hlen ≥ 2×len
    Ind ↩ bits _hash
    Next ↩ hlen⊸>⊸× 1+⊢
    table ↩ hlen ⥊ ¯1
  }
  ST ← {table 𝕨⌾(𝕩⊸⊑)↩⋄@}
  Count ⇐ {𝕊:len}

  # Lookup and modify
  Find ← { 𝕊 key:
    T ← ("Not found!"!¯1⊸≠)⊸⊢ ⊑⟜table
    table ⊑˜ Next•_while_(key≢keys⊑˜T) Ind key
  }
  tombstone ← {⇐}
  Delete ⇐ { 𝕊 key:
    keys tombstone⌾((Find key)⊸⊑)↩
    DecLen 1
    self
  }
  Has ⇐ { 𝕊 key:
    h←1 ⋄ Next•_while_(¯1⊸≠◶⟨{𝕊:h↩0},key≢⊑⟜keys⟩⊑⟜table) Ind key ⋄ h
  }
  DefKey ← { 𝕊 key:
    Next•_while_(¯1⊸≠◶⟨0,"Duplicate key"!key≢⊑⟜keys⟩⊑⟜table) Ind key
  }
  Set ⇐ { 𝕊 key:
    i ← Next•_while_(¯1⊸≠◶⟨0,key≢⊑⟜keys⟩ ⊑⟜table) Ind key
    t ← i⊑table
    {
      len ST i ⋄ keys∾↩<key ⋄ IncLen 1
    }
    self
  }
  AsList ⇐ {𝕊 : keys}
  Values ⇐ {𝕊 : 1 ; 𝕊⁼ : tombstone⊸≢¨⊸/keys ; 𝕨𝕊⁼𝕩 : 1⋈˜¨tombstone⊸≢¨⊸/keys}
  Copy ⇐ {𝕊 : HashSet keys}

  # Resize
  Init ← {
    InitSize 𝕩
    (↕𝕩) ST⟜DefKey¨ keys
  }
  ClearTombs ← {𝕊:
    len ≡ ≠keys ? @ ;
    ! len ≡ +´ k ← tombstone⊸≢¨ keys
    keys k⊸/↩
    k
  }
  Renumber ← { # Based on filter 𝕩
    table ⊏↩ 1-˜(𝕩×+`𝕩)∾0
    @
  }
  IncLen ← {
    len +↩ 𝕩
    hlen ≥ 2 × ≠keys ? @ ;
    k ← ClearTombs@
    hlen ≥ 2.25 × len ? Renumber k ;
    Init len
  }
  DecLen ← {
    len -↩ 𝕩
    hlen < 6 × len ? @ ;
    ClearTombs@
    Init len
  }
  Init len ← ≠keys
}
