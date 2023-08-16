#!/usr/bin/env cbqn
env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝v}}
util ← •Import "/util.bqn"∾˜"." env.Var⌾⋈ "BQN_LIB"
⟨md5⟩ ⇐

Encode8 ← {⟨8‿'u',1‿'u'⟩•bit._cast 𝕩}
"encode 0" util.Debug Encode8⋈0
"encode 1" util.Debug Encode8⋈1
Encode32 ← {⟨8‿'u',1‿'u'⟩•bit._cast{𝕩+16×𝕨}´˘∘‿2⥊8↑"0123456789ABCDEF"⊐𝕩}
# Encode512 ← {⟨8‿'u',1‿'u'⟩•bit._cast{𝕩+16×𝕨}´˘∘‿2⥊128↑"0123456789ABCDEF"⊐𝕩}
k ← Encode32¨⟨
  "D76AA478","E8C7B756","242070DB","C1BDCEEE"
  "F57C0FAF","4787C62A","A8304613","FD469501"
  "698098D8","8B44F7AF","FFFF5BB1","895CD7BE"
  "6B901122","FD987193","A679438E","49B40821"
  "F61E2562","C040B340","265E5A51","E9B6C7AA"
  "D62F105D","02441453","D8A1E681","E7D3FBC8"
  "21E1CDE6","C33707D6","F4D50D87","455A14ED"
  "A9E3E905","FCEFA3F8","676F02D9","8D2A4C8A"
  "FFFA3942","8771F681","6D9D6122","FDE5380C"
  "A4BEEA44","4BDECFA9","F6BB4B60","BEBFBC70"
  "289B7EC6","EAA127FA","D4EF3085","04881D05"
  "D9D4D039","E6DB99E5","1FA27CF8","C4AC5665"
  "F4292244","432AFF97","AB9423A7","FC93A039"
  "655B59C3","8F0CCC92","FFEFF47D","85845DD1"
  "6FA87E4F","FE2CE6E0","A3014314","4E0811A1"
  "F7537E82","BD3AF235","2AD7D2BB","EB86D391"
⟩
a‿b‿c‿d ← Encode32¨⟨"67452301","EFCDAB89","98BADCFE","10325476"⟩

Md5 ← {
  !∧´(255⊸≥-⟜@)¨𝕩
  msg_len_bits ← 8×≠𝕩
  "msg_bits" util.Debug msg ← ∾{⟨8‿'u',1‿'u'⟩•bit._cast ⋈𝕩-@}¨𝕩
  msg ∾⟜(Encode8⋈1) ↩
  msg ↩ {𝕩∾Encode8⋈0}•_while_(448≠512|≠)msg
  msg ∾⟜(64↑⟨32‿'u',1‿'u'⟩•bit._cast⋈msg_len_bits) ↩
  (≠msg)!0≡512|≠msg
  F ← {x‿y‿z : (x 1‿1 •bit._and y) 1‿1 •bit._or ((1‿1 •bit._not x) 1‿1 •bit._and z)}
  G ← {x‿y‿z : (x 1‿1 •bit._and z) 1‿1 •bit._or (y 1‿1 •bit._and (1‿1 •bit._not z))}
  H ← {x‿y‿z : x 1‿1 •bit._xor y 1‿1 •bit._xor z}
  I ← {x‿y‿z : y 1‿1 •bit._xor (x 1‿1 •bit._or (1‿1 •bit._not z))}
  abcd ← a‿b‿c‿d{block 𝕊 a‿b‿c‿d :
    t ← block # TODO
    word_block ← ∘‿32⥊block
    aa‿bb‿cc‿dd ← a‿b‿c‿d
    Op1 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(F b‿c‿d)+(k⊑word_block)+(i⊑t)}
    Op2 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(G b‿c‿d)+(k⊑word_block)+(i⊑t)}
    Op3 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(H b‿c‿d)+(k⊑word_block)+(i⊑t)}
    Op4 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(I b‿c‿d)+(k⊑word_block)+(i⊑t)}
    a‿b‿c‿d
  }´∘‿512⥊msg
  0
}

•Show Md5 "A"
