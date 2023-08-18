#!/usr/bin/env cbqn
env ← {v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env",Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
⟨Md5⟩‿util ← •Import¨"/MD5.bqn"‿"/util.bqn"∾˜¨<∾env.Var⋈"BQN_LIB"

"call external process" util.Debug 1000 {¯1↓1⊑ •SH "md5"‿"-qs"‿𝕩}•_timed "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
"native implementation" util.Debug 1000 Md5•_timed "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
