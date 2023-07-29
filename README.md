# Bup
BQN utility package

## Execution Convention

- app.bqn

```apl
#!/usr/bin/env cbqn
env←{v⇐⍉>⊑∘⊐⟜'='⊸(↑⋈1⊸↓∘↓)¨{-¬(¬×1++`)𝕩=@+10}⊸⊔1⊑•SH<"env"⋄Var⇐{⊐⟜𝕩⊸⊏⟜(∾⟜𝕨)˝v}}
lib ← •Import "/util.bqn"∾˜"." env.Var⌾⋈ "BQN_LIB"

...

```

- execute

```sh
BQN_LIB=~/.config/bqn cbqn app.bqn
```

or

```sh
BQN_LIB=. cbqn app.bqn
```

The latter is equivalent to

```sh
cbqn app.bqn
```
