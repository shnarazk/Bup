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
    a b‿c‿d‿00‿07‿01⊸Op1 ↩
    d a‿b‿c‿01‿12‿02⊸Op1 ↩
    c d‿a‿b‿02‿17‿03⊸Op1 ↩
    b c‿d‿a‿03‿22‿04⊸Op1 ↩

    a b‿c‿d‿04‿07‿05⊸Op1 ↩
    d a‿b‿c‿05‿12‿06⊸Op1 ↩
    c d‿a‿b‿06‿17‿07⊸Op1 ↩
    b c‿d‿a‿07‿22‿08⊸Op1 ↩

    a b‿c‿d‿08‿07‿09⊸Op1 ↩
    d a‿b‿c‿09‿12‿10⊸Op1 ↩
    c d‿a‿b‿10‿17‿11⊸Op1 ↩
    b c‿d‿a‿11‿22‿12⊸Op1 ↩

    a b‿c‿d‿12‿07‿13⊸Op1 ↩
    d a‿b‿c‿13‿12‿14⊸Op1 ↩
    c d‿a‿b‿14‿17‿15⊸Op1 ↩
    b c‿d‿a‿15‿22‿16⊸Op1 ↩

    Op2 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(G b‿c‿d)+(k⊑word_block)+(i⊑t)}
    a b‿c‿d‿01‿05‿17⊸Op2 ↩
    d a‿b‿c‿06‿09‿18⊸Op2 ↩
    c d‿a‿b‿11‿14‿19⊸Op2 ↩
    b c‿d‿a‿00‿20‿20⊸Op2 ↩

    a b‿c‿d‿05‿05‿21⊸Op2 ↩
    d a‿b‿c‿10‿09‿22⊸Op2 ↩
    c d‿a‿b‿15‿14‿23⊸Op2 ↩
    b c‿d‿a‿04‿20‿24⊸Op2 ↩

    a b‿c‿d‿09‿05‿25⊸Op2 ↩
    d a‿b‿c‿14‿09‿26⊸Op2 ↩
    c d‿a‿b‿03‿14‿27⊸Op2 ↩
    b c‿d‿a‿08‿20‿28⊸Op2 ↩

    a b‿c‿d‿13‿05‿29⊸Op2 ↩
    d a‿b‿c‿02‿09‿30⊸Op2 ↩
    c d‿a‿b‿07‿14‿31⊸Op2 ↩
    b c‿d‿a‿12‿20‿32⊸Op2 ↩

    Op3 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(H b‿c‿d)+(k⊑word_block)+(i⊑t)}
    a b‿c‿d‿05‿04‿33⊸Op3 ↩
    d a‿b‿c‿08‿11‿34⊸Op3 ↩
    c d‿a‿b‿11‿16‿35⊸Op3 ↩
    b c‿d‿a‿14‿23‿36⊸Op3 ↩

    a b‿c‿d‿01‿04‿37⊸Op3 ↩
    d a‿b‿c‿04‿11‿38⊸Op3 ↩
    c d‿a‿b‿07‿16‿39⊸Op3 ↩
    b c‿d‿a‿10‿23‿40⊸Op3 ↩

    a b‿c‿d‿13‿04‿41⊸Op3 ↩
    d a‿b‿c‿00‿11‿42⊸Op3 ↩
    c d‿a‿b‿03‿16‿43⊸Op3 ↩
    b c‿d‿a‿06‿23‿44⊸Op3 ↩

    a b‿c‿d‿09‿04‿45⊸Op3 ↩
    d a‿b‿c‿12‿11‿46⊸Op3 ↩
    c d‿a‿b‿15‿16‿47⊸Op3 ↩
    b c‿d‿a‿02‿23‿48⊸Op3 ↩

    Op4 ← {k‿s‿i‿b‿c‿d 𝕊 a : b+(«⍟s)a+(I b‿c‿d)+(k⊑word_block)+(i⊑t)}
    a b‿c‿d‿00‿06‿49⊸Op4 ↩
    d a‿b‿c‿07‿10‿50⊸Op4 ↩
    c d‿a‿b‿14‿15‿51⊸Op4 ↩
    b c‿d‿a‿05‿21‿52⊸Op4 ↩

    a b‿c‿d‿12‿06‿53⊸Op4 ↩
    d a‿b‿c‿03‿10‿54⊸Op4 ↩
    c d‿a‿b‿10‿15‿55⊸Op4 ↩
    b c‿d‿a‿01‿21‿56⊸Op4 ↩

    a b‿c‿d‿08‿06‿57⊸Op4 ↩
    d a‿b‿c‿15‿10‿58⊸Op4 ↩
    c d‿a‿b‿06‿15‿59⊸Op4 ↩
    b c‿d‿a‿13‿21‿60⊸Op4 ↩

    a b‿c‿d‿04‿06‿61⊸Op4 ↩
    d a‿b‿c‿11‿10‿62⊸Op4 ↩
    c d‿a‿b‿02‿15‿63⊸Op4 ↩
    b c‿d‿a‿09‿21‿64⊸Op4 ↩

    a aa⊸⟨32,32⟩•bit._add ↩
    b bb⊸⟨32,32⟩•bit._add ↩
    c cc⊸⟨32,32⟩•bit._add ↩
    d dd⊸⟨32,32⟩•bit._add ↩

    a‿b‿c‿d
  }´∘‿512⥊msg
  0
}

•Show Md5 "A"
