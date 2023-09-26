Ref ⇐ {𝕩.Self 𝕩}∘{
  Self ⇐ {self ↩ 𝕩}
  ref ⇐ 𝕩
  Set ⇐ {ref ↩ 𝕩 ⋄ self}
  _modify ⇐ {ref 𝔽 ↩ 𝕩 ⋄ self}
}

# - instantiate
#     r ← Ref ↕10 # subject
# - to repeat appending π
#     {∾ 𝕩._modify π ⋄ 𝕩}•_while_{100>≠⟜𝕩.ref}Ref⟨⟩
# - to drop the head
#     ↓˜ r._modify 1
