# Bup
BQN utility package

## Caller

- app.bqn
```apl
#!/usr/bin/env cbqn
env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜@)˝v}}
lib ← •Import"/util.bqn"∾˜∾env.Var⌾⋈"BQN_LIB"

...

```

- execute
```sh
BQN_LIB=/.config/bqn app.bqn
```
