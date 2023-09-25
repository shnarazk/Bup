Ref ⇐ {
  ref ⇐ 𝕩
  Set ⇐ {ref ↩ 𝕩}
  _apply ⇐ {ref 𝔽 ↩ 𝕩}
}

# - instantiate
#     r ← Ref ↕10 # subject
# - to repeat appending π
#     {∾ 𝕩._apply π ⋄ 𝕩}•_while_{100>≠⟜𝕩.ref}Ref⟨⟩
# - to drop the head
#     ↓˜ r._apply 1
