#!/usr/bin/env cbqn
env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝v}}
# util ← •Import "/util.bqn"∾˜"." env.Var⌾⋈ "BQN_LIB"
⟨Md5⟩ ⇐

modulo ← 2⋆8
SwapByteOrder ← ⌽·⥊·<˘∘‿8⊸⥊

Encode32 ← {∾⌽((⟨8‿'i',1‿'u'⟩•bit._cast)∘⋈∘{127<𝕩 ? 𝕩-modulo ; 𝕩})¨{𝕩+16×𝕨}´˘∘‿2⥊"0123456789ABCDEF"⊐𝕩}
ToString ← {⥊((⊑⟜"0123456789abcdef"¨·16⊸(⌊∘(÷˜)⋈|)·{𝕨+2×𝕩}´>)˘SwapByteOrder)𝕩}
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
F ← {x‿y‿z : z 32‿32 •bit._xor x 32‿32 •bit._and y 32‿32 •bit._xor z}
# F ← {x‿y‿z : (x 32‿32 •bit._and y) 32‿32 •bit._or z 32‿32 •bit._and 32‿1 •bit._not x}
G ← {x‿y‿z : y 32‿32 •bit._xor z 32‿32 •bit._and x 32‿32 •bit._xor y}
# G ← {x‿y‿z : (x 32‿32 •bit._and z) 32‿32 •bit._or y 32‿32 •bit._and 32‿1 •bit._not z}
H ← {x‿y‿z : x 32‿32 •bit._xor y 32‿32 •bit._xor z}
J ← {x‿y‿z : y 32‿32 •bit._xor x 32‿32 •bit._or 32‿1 •bit._not z}
Add32 ← 32‿1•bit._add

ToMd5 ← {
  !∧´(255⊸≥-⟜@)¨message ← 𝕩
  msg_len_bits ← 8×≠𝕩
  msg ← ∾{⟨8‿'u',1‿'u'⟩•bit._cast ⋈𝕩-@}¨𝕩
  msg ∾⟜⟨0,0,0,0,0,0,0,1⟩ ↩
  msg ↩ {𝕩∾8↑0}•_while_(448≠512|≠)msg
  msg ↩ msg{
    𝕩∾⟨8,1‿'u'⟩•bit._cast⋈{127<𝕩 ? 𝕩-modulo ; 𝕩}𝕨
  }´2⊑{c‿v‿l : ⟨-¬c,v⌊∘÷modulo,l∾˜modulo|v⟩}•_while_(0<⊑)8‿msg_len_bits‿⟨⟩
  (≠msg)!0≡512|≠msg
  abcd ← a‿b‿c‿d{block 𝕊 a‿b‿c‿d :
    word_block ← ⥊<˘∘‿32⥊block
    _op ← {b‿c‿d‿k‿s‿i 𝔽 _𝕣 a : b Add32 s⊸⌽⁼a Add32(𝔽 b‿c‿d)Add32(k⊑word_block)Add32 i⊑t}
    {
      a b‿c‿d‿(0+𝕩)‿07‿(1+𝕩)⊸(F _op) ↩
      d a‿b‿c‿(1+𝕩)‿12‿(2+𝕩)⊸(F _op) ↩
      c d‿a‿b‿(2+𝕩)‿17‿(3+𝕩)⊸(F _op) ↩
      b c‿d‿a‿(3+𝕩)‿22‿(4+𝕩)⊸(F _op) ↩
      4+𝕩
    }•_while_(16⊸>)0
    # "phase1" util.Debug ToString¨ a‿b‿c‿d
    {
      a b‿c‿d‿(16| 1+𝕩)‿05‿(1+𝕩)⊸(G _op) ↩
      d a‿b‿c‿(16| 6+𝕩)‿09‿(2+𝕩)⊸(G _op) ↩
      c d‿a‿b‿(16|11+𝕩)‿14‿(3+𝕩)⊸(G _op) ↩
      b c‿d‿a‿(16|16+𝕩)‿20‿(4+𝕩)⊸(G _op) ↩
      4+𝕩
    }•_while_(32⊸>)16
    # "phase2" util.Debug ToString¨ a‿b‿c‿d
    {x‿y :
      a b‿c‿d‿(16| 3+y)‿04‿(1+x)⊸(H _op) ↩
      d a‿b‿c‿(16| 6+y)‿11‿(2+x)⊸(H _op) ↩
      c d‿a‿b‿(16| 9+y)‿16‿(3+x)⊸(H _op) ↩
      b c‿d‿a‿(16|12+y)‿23‿(4+x)⊸(H _op) ↩
      ⟨4+x,12+y⟩
    }•_while_(48>⊑)32‿2
    # "phase3" util.Debug ToString¨ a‿b‿c‿d
    {x‿y :
      a b‿c‿d‿(16|   y)‿06‿(1+x)⊸(J _op) ↩
      d a‿b‿c‿(16| 7+y)‿10‿(2+x)⊸(J _op) ↩
      c d‿a‿b‿(16|14+y)‿15‿(3+x)⊸(J _op) ↩
      b c‿d‿a‿(16|21+y)‿21‿(4+x)⊸(J _op) ↩
      ⟨4+x,28+y⟩
    }•_while_(64>⊑)48‿0
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
