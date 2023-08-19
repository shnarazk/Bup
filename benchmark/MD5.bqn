#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
⟨Md5⟩‿util ← •Import¨"/MD5.bqn"‿"/util.bqn"∾˜¨<∾env.Var⋈"BQN_LIB"

!"d41d8cd98f00b204e9800998ecf8427e"≡ Md5 ""
!"0cc175b9c0f1b6a831c399e269772661"≡ Md5 "a"
!"900150983cd24fb0d6963f7d28e17f72"≡ Md5 "abc"
!"f96b697d7cb7938d525a2f31aaf161d0"≡ Md5 "message digest"
!"c3fcd3d76192e4007dfb496cca67e13b"≡ Md5 "abcdefghijklmnopqrstuvwxyz"
!"d174ab98d277d9f5a5611c2c9f419d9f"≡ Md5 m ← "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
!"57edf4a22be3c955ac49da2e2107b67a"≡ Md5 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

("external process len="∾(•Fmt ≠m)) util.Debug 1000 {¯1↓1⊑ •SH "md5"‿"-qs"‿𝕩}•_timed m
("native implement len="∾(•Fmt ≠m)) util.Debug 1000 Md5•_timed m
l ← ≠m7 ← ∾˜⍟7 m
("external process len="∾(•Fmt l)) util.Debug 1000 {¯1↓1⊑ •SH "md5"‿"-qs"‿𝕩}•_timed m7
("native implement len="∾(•Fmt l)) util.Debug 1000 Md5•_timed m7
