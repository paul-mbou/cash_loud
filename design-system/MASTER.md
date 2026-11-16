# Design System — Cash Loud (Stall Board · voice-soft craft)

## Intent

- **Product:** Voice-first offline POS + business advisor for Francophone African micro-merchants (Cameroon first).
- **Audience:** Market vendors — busy hands, noisy stalls, budget Android, patchy internet.
- **Subject world:** Stall **price board** + modern voice tool — soft atmosphere, chalk-clear money, one thumb to sell.
- **Vibe:** Soft-premium · voice-first · decisive (craft attitude from voice-AI refs; **not** their purple brand).
- **Signature — “Floating Voice Dock”:** Dark floating pill nav with a raised **chili mic** in the center (always reachable). Accueil is an open soft board: quiet money card + large speak prompt + waveform while listening.
- **Aesthetic ambition:** Feel as calm and intentional as premium voice apps — still unmistakably a Cameroon caisse, not a transcription gadget.

### Reference craft (take / leave)

**Take:** soft gradient atmosphere · large centered voice copy · floating dock with center CTA · soft elevated surfaces · waveform feedback · generous radius · Mode vocal badge.  
**Leave:** purple/lavender palettes · home feature-card grids · history chrome on Accueil · social share kits · medical chat dashboards.

### Rejected directions (do not revive)

- Flat cement + lonely red FAB  
- **Canopy Brass**  
- Generic emerald banking dock  
- Purple fintech / lavender glass clones of the refs  

### Product pillars

1. Safe voice checkout (confirm before commit)  
2. Ardoise + WhatsApp reminders  
3. Proactive AI coach  
4. Offline-first  

## Typography

| Role | Family | Weights | Use |
|------|--------|---------|-----|
| Display | **Sora** | 600–800 | Amounts, voice prompt |
| Body | **DM Sans** | 400–600 | French UI |
| Data | **IBM Plex Mono** | 500 | Times, SKUs |

Scale: voice prompt **28–32** / display-xl **40** / title **22** / body **16** / caption **12**  
Center mic: **64** dp raised above dock.

## Spacing & radius

- Grid 8 · page padding 20 · dock inset 20 · dock bottom margin 12  
- Radius: `sm` 12 · `md` 18 · `lg` 24 · `pill` 999 · money card `lg`  
- Accueil: soft open field — no mid-page feature grids.

## Color roles (semantic)

**Light & soft:** nearly-white mist, white floating dock, muted sage, soft coral mic, warm soft gold. No heavy dark green bar.

| Role | Light | Dark | Notes |
|------|-------|------|-------|
| bg | `#F5FAF7` | `#101C19` | Soft field |
| bg-glow | `#FCFDFC` | `#162420` | Near-white lift |
| surface | `#F0F7F3` | `#152420` | Lists |
| surface-elevated | `#FFFFFF` | `#1C2E28` | Cards / dock |
| text-primary | `#243832` | `#E8F3EE` | Softer ink |
| text-secondary | `#7A9088` | `#9BB0A6` | |
| text-inverse | `#FFFFFF` | `#101C19` | On primary |
| border | `#E4EEE9` | `#2E4039` | Soft hairline |
| primary | `#2F7A64` | `#4EC49A` | Soft sage |
| primary-muted | `#E4F2EC` | `#1A332C` | |
| accent | `#C47A2E` | `#E0B05A` | Soft money |
| accent-muted | `#F9F0E0` | `#3A3014` | |
| voice | `#E85A64` | `#FF6B75` | Soft coral mic |
| voice-muted | `#FCE8EA` | `#3D1E22` | |
| dock | `#FFFFFF` | `#1C2E28` | Light pill |
| dock-icon | `#8AA399` | `#9BB0A6` | Inactive |
| success | `#3B9A6A` | `#56D49A` | |
| warning | `#C4892A` | `#F0C05A` | |
| danger | `#D4544A` | `#FF7A70` | |
| focus-ring | `#2F7A64` | `#E0B05A` | |
| overlay | `rgba(12,31,26,0.35)` | `rgba(0,0,0,0.56)` | |

## Elevation

- Very soft shadows (`0 10 28 rgba(36,56,50,0.05–0.07)`).  
- Dark: border + gentle lift.

## Motion

- Listening: soft waveform + optional board rings; reduced motion → static bars.  
- Confirm: gold stamp ≤400ms.  
- Dock mic: scale press feedback.

## Components

- **Accueil hub:** soft gradient · masonry summary cards (Ventes, Stock, Ardoise, Boutique, Coach) · **Voice FAB** only (no bottom nav).  
- **Hub cards:** rounded 24 · soft border · icon wash · chevron · tap → screen.  
- **Lists:** soft dividers on pushed screens with back affordance.  
- **Confirm sheet:** clean elevated sheet; primary confirm; soft gold total.

## Anti-patterns

- Purple / lavender glass  
- Canopy brass / stripes  
- Feature-card grids on Accueil  
- Dashboard stats strips  
- Mic buried only on Accueil while nav has no voice  

## Stack

Flutter ThemeExtension · Sora + DM Sans + IBM Plex Mono · page overrides.
