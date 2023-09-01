# Chinese Remainder Theorem
# that returns a‿x such that:
# - x ≡ rr mod aq
# - x ≡ br mod bq
# where a is the modulo for x
CRT ⇐ {bq‿br 𝕊 aq‿ar :
  n ← aq÷˜(aq⊸+)•_while_(1≠bq⊸|)0
  nar‿nbr ← bq|n×ar‿br
  m ← (nar<nbr)◶⟨bq+nbr-nar,nbr-nar⟩@
  ⟨aq×bq,ar+m×aq⟩
}
# !8=1⊑CRT´⟨5‿3,3‿2⟩
# !23=1⊑CRT´⟨5‿3,3‿2,2‿7⟩
# (2‿0 CRT 5‿0)! 10‿10≡2‿0 CRT 5‿0
# (3‿1 CRT 2‿0 CRT 5‿0)! 30‿40≡3‿1 CRT 2‿0 CRT 5‿0
