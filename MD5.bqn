#!/usr/bin/env cbqn
env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝v}}
# util ← •Import "/util.bqn"∾˜"." env.Var⌾⋈ "BQN_LIB"
⟨Md5⟩ ⇐

modulo ← 2⋆8
SwapByteOrder ← ⌽·⥊·<˘∘‿8⊸⥊
SwapBitOrder ← ⥊·⌽˘∘‿8⊸⥊

Encode32 ← {∾⌽(⌽∘(⟨8‿'i',1‿'u'⟩•bit._cast)∘⋈∘{127<𝕩 ? 𝕩-modulo ; 𝕩})¨{𝕩+16×𝕨}´˘∘‿2⥊"0123456789ABCDEF"⊐𝕩}
# Encode32 ← {∾⌽(⌽∘(8⊸↑)∘(⟨16‿'u',1‿'u'⟩•bit._cast)∘⋈)¨{𝕩+16×𝕨}´˘∘‿2⥊"0123456789ABCDEF"⊐𝕩}
ToString ← {⥊((⊑⟜"0123456789abcdef"¨·16⊸(⌊∘(÷˜)⋈|)·{𝕨+2×𝕩}´·⌽>)˘SwapByteOrder)𝕩}
t ← Encode32¨⟨
  "00000000"
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
# "ToString encode32 8FFF0000" util.Debug ToString Encode32 "8FFF0000"
a‿b‿c‿d ← Encode32¨⟨"67452301","EFCDAB89","98BADCFE","10325476"⟩
F ← {x‿y‿z : (x 32‿32 •bit._and y) 32‿32 •bit._or ((32‿32 •bit._not x) 32‿32 •bit._and z)}
G ← {x‿y‿z : (x 32‿32 •bit._and z) 32‿32 •bit._or (y 32‿32 •bit._and (1‿1 •bit._not z))}
H ← {x‿y‿z : x 32‿32 •bit._xor y 32‿32 •bit._xor z}
J ← {x‿y‿z : y 32‿32 •bit._xor (x 32‿32 •bit._or (1‿1 •bit._not z))}
Add32 ← SwapBitOrder∘(32‿1•bit._add)○SwapBitOrder

ToMd5 ← {
  !∧´(255⊸≥-⟜@)¨message ← 𝕩
  msg_len_bits ← 8×≠𝕩
  msg ← ∾{⌽⟨8‿'u',1‿'u'⟩•bit._cast ⋈𝕩-@}¨𝕩
  msg ∾⟜⟨1,0,0,0,0,0,0,0⟩ ↩
  msg ↩ {𝕩∾8↑0}•_while_(448≠512|≠)msg
  msg ↩ msg{
    𝕩∾⌽8↑⟨16,1‿'u'⟩•bit._cast⋈𝕨
  }´2⊑{c‿v‿l : ⟨-¬c,v⌊∘÷modulo,l∾˜modulo|v⟩}•_while_(0<⊑)8‿msg_len_bits‿⟨⟩
  (≠msg)!0≡512|≠msg
  abcd ← a‿b‿c‿d{block 𝕊 a‿b‿c‿d :
    word_block ← ⥊<˘∘‿32⥊block
    # backup ← a‿b‿c‿d
    Op1 ← {b‿c‿d‿k‿s‿i 𝕊 a : b Add32 s⊸⌽⁼⌾SwapBitOrder a Add32(F b‿c‿d)Add32(k⊑word_block)Add32 i⊑t}
    # "0‿14‿15⊑X" util.Debug ToString¨⟨0⊑word_block,14⊑word_block,15⊑word_block⟩
    # "a+f" util.Debug ToString¨⟨a Add32(F b‿c‿d)⟩
    # "a+f+X+T" util.Debug ToString a Add32(F b‿c‿d)Add32(0⊑word_block)Add32 1⊑t
    a b‿c‿d‿00‿07‿01⊸Op1 ↩
    # "step1" util.Debug ToString¨ a‿b‿c‿d
    d a‿b‿c‿01‿12‿02⊸Op1 ↩
    c d‿a‿b‿02‿17‿03⊸Op1 ↩
    b c‿d‿a‿03‿22‿04⊸Op1 ↩
    # "step4" util.Debug ToString¨ a‿b‿c‿d

    a b‿c‿d‿04‿07‿05⊸Op1 ↩
    d a‿b‿c‿05‿12‿06⊸Op1 ↩
    c d‿a‿b‿06‿17‿07⊸Op1 ↩
    b c‿d‿a‿07‿22‿08⊸Op1 ↩
    # "step8" util.Debug ToString¨ a‿b‿c‿d

    a b‿c‿d‿08‿07‿09⊸Op1 ↩
    d a‿b‿c‿09‿12‿10⊸Op1 ↩
    c d‿a‿b‿10‿17‿11⊸Op1 ↩
    b c‿d‿a‿11‿22‿12⊸Op1 ↩
    # "stepC" util.Debug ToString¨ a‿b‿c‿d

    a b‿c‿d‿12‿07‿13⊸Op1 ↩
    d a‿b‿c‿13‿12‿14⊸Op1 ↩
    c d‿a‿b‿14‿17‿15⊸Op1 ↩
    b c‿d‿a‿15‿22‿16⊸Op1 ↩
    # "phase1" util.Debug ToString¨ a‿b‿c‿d

    Op2 ← {b‿c‿d‿k‿s‿i 𝕊 a : b Add32 s⊸⌽⁼⌾SwapBitOrder a Add32(G b‿c‿d)Add32(k⊑word_block)Add32 i⊑t}
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
    # "phase2" util.Debug ToString¨ a‿b‿c‿d

    Op3 ← {b‿c‿d‿k‿s‿i 𝕊 a : b Add32 s⊸⌽⁼⌾SwapBitOrder a Add32(H b‿c‿d)Add32(k⊑word_block)Add32 i⊑t}
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
    # "phase3" util.Debug ToString¨ a‿b‿c‿d

    Op4 ← {b‿c‿d‿k‿s‿i 𝕊 a : b Add32 s⊸⌽⁼⌾SwapBitOrder a Add32(J b‿c‿d)Add32(k⊑word_block)Add32 i⊑t}
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
    # "phase4" util.Debug ToString¨ a‿b‿c‿d

    𝕩 Add32¨ a‿b‿c‿d
  }´⌽<˘∘‿512⥊msg
  ⌽⌾(⥊∘(<˘)∘‿8⊸⥊)¨abcd
}

Md5 ← ∾ToString¨∘ToMd5

!"d41d8cd98f00b204e9800998ecf8427e"≡ Md5 ""
!"0cc175b9c0f1b6a831c399e269772661"≡ Md5 "a"
!"900150983cd24fb0d6963f7d28e17f72"≡ Md5 "abc"
!"f96b697d7cb7938d525a2f31aaf161d0"≡ Md5 "message digest"
!"c3fcd3d76192e4007dfb496cca67e13b"≡ Md5 "abcdefghijklmnopqrstuvwxyz"
!"d174ab98d277d9f5a5611c2c9f419d9f"≡ Md5 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
!"57edf4a22be3c955ac49da2e2107b67a"≡ Md5 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

# •Show ((∾⟜(8⊸×)≠)⊸⋈(≍○⋈)Md5)"message digest"
# •Show ((∾⟜(8⊸×)≠)⊸⋈(≍○⋈)Md5)"abcdefghijklmnopqrstuvwxyz"
# •Show ((∾⟜(8⊸×)≠)⊸⋈(≍○⋈)Md5)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
