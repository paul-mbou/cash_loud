# Page — Confirmation de vente

Overrides for the safe voice checkout sheet.

## Job

Show the AI draft so the merchant can **see, edit, or reject** before anything is saved. Satisfaction = control over money.

## Rules

- Never auto-dismiss into a commit.
- Primary CTA: **Confirmer la vente** (primary / bottle green).
- Secondary: **Annuler** (dismiss without save).
- Show raw transcript when available.
- Editable lines: article, qty, unit price.
- Optional customer → marks ardoise/credit for later pillar.
- Total uses accent (money gold) AmountText.
- On confirm: brief gold “stamp” on total (≤400ms) then close.
- Sheet surfaces use `surface-elevated`; **floating** card (inset margins, full 28 radius, soft shadow) — not edge-to-edge.
