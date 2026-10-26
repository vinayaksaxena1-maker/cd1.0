---
name: CardSaathi Design System
colors:
  surface: '#f1fcf4'
  surface-dim: '#d1ddd5'
  surface-bright: '#f1fcf4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#ebf6ee'
  surface-container: '#e5f1e8'
  surface-container-high: '#dfebe3'
  surface-container-highest: '#dae5dd'
  on-surface: '#141e19'
  on-surface-variant: '#404944'
  inverse-surface: '#28332d'
  inverse-on-surface: '#e8f4eb'
  outline: '#707973'
  outline-variant: '#bfc9c2'
  surface-tint: '#2c6952'
  primary: '#003827'
  on-primary: '#ffffff'
  primary-container: '#0d513b'
  on-primary-container: '#84c2a6'
  inverse-primary: '#95d4b7'
  secondary: '#59605a'
  on-secondary: '#ffffff'
  secondary-container: '#d8dfd7'
  on-secondary-container: '#5b635d'
  tertiary: '#452b00'
  on-tertiary: '#ffffff'
  tertiary-container: '#633f00'
  on-tertiary-container: '#eca73f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b0f0d2'
  primary-fixed-dim: '#95d4b7'
  on-primary-fixed: '#002115'
  on-primary-fixed-variant: '#0d513b'
  secondary-fixed: '#dde4dd'
  secondary-fixed-dim: '#c1c8c1'
  on-secondary-fixed: '#161d18'
  on-secondary-fixed-variant: '#414843'
  tertiary-fixed: '#ffddb4'
  tertiary-fixed-dim: '#ffb953'
  on-tertiary-fixed: '#291800'
  on-tertiary-fixed-variant: '#633f00'
  background: '#f1fcf4'
  on-background: '#141e19'
  surface-variant: '#dae5dd'
  background-canvas: '#FAF7F0'
  surface-card: '#FFFFFF'
  surface-sage: '#EAF1E9'
  accent-saffron: '#E6A23A'
  accent-saffron-container: '#FDF5E6'
  text-primary: '#17211C'
  text-secondary: '#58675F'
  border-subtle: '#E2E8E2'
typography:
  headline-lg:
    fontFamily: Noto Serif
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 38px
  headline-lg-mobile:
    fontFamily: Noto Serif
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
  headline-md:
    fontFamily: Noto Serif
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Noto Serif
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '500'
    lineHeight: 22px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.75rem
---

## Brand & Style

This design system is tailored for Indian small-business owners, traders, founders, and professionals who manage relationships in fast-paced commercial ecosystems. The emotional profile balances trust, warmth, and quiet efficiency: it feels like an attentive personal partner rather than a rigid enterprise database.

The visual style blends **Material 3 architectural logic** with an **organic tactile finish**. Instead of sterile grays and stark whites, the interface uses a warm ivory canvas (`#FAF7F0`), deep forest greenery (`#0D513B`), and restrained saffron highlights (`#E6A23A`). The layout respects natural bilingual cadence, offering equal optical prominence and vertical breathing room to both English and Devanagari typography.

## Colors

The color palette establishes an approachable, grounded presence suitable for daily business utility.

- **Primary (`#0D513B`):** Forest Green commands high-priority zones—the hero header, primary action buttons, key icon highlights, and selected bottom navigation states.
- **Secondary / Surface Sage (`#EAF1E9`):** Soft, desaturated sage used for tonal badge containers, pill chips, and secondary interaction surfaces.
- **Tertiary / Saffron Accent (`#E6A23A`):** Used deliberately for alerts, time-critical indicators, upcoming reminder badges, and brand identity flourishes. It is never overused, ensuring follow-ups remain eye-catching.
- **Neutral / Text (`#17211C`):** Deep carbon forest-charcoal ensuring WCAG AAA legibility against the Warm Ivory (`#FAF7F0`) background canvas and pure white card surfaces (`#FFFFFF`).

## Typography

The typographic hierarchy bridges classic editorial authority and modern mobile readability:
- **Headlines (`Noto Serif`):** Delivers warmth, personal connection, and timeless respect in greetings and top-level screen anchors. Noto Serif offers native parity with Devanagari letterforms, preventing awkward baseline drift or height mismatches when switching between English and Hindi.
- **Body & Labels (`Plus Jakarta Sans`):** Clean, geometric sans-serif with wide apertures and generous x-height. Retains extreme legibility on contact numbers, business designations, and OCR data review inputs on compact mobile viewports.
- **Devanagari Handling:** Ensure line heights provide a 4px cushion over standard English metrics to accommodate matras (vowel signs) above and below characters without truncation.

## Layout & Spacing

The layout is built on a fluid 4-column mobile grid calibrated around a standard 393 × 852 logical-pixel frame, scaling down reliably to 360px widths.

- **Margins & Gutters:** Outer content margins are locked to `1rem` (16px), allowing maximum breathing space for contact rows while preserving comfortable touch margins from screen edges.
- **Vertical Cadence:** Sections adhere to an 8px base rhythm (`space-sm` for compact internal padding, `space-md` for standard card padding, and `space-xl` for sectional spacing).
- **Hero Stacking:** Top headers anchor with full-width or rounded container caps in forest green, transitioning cleanly into floating content surfaces over the warm ivory canvas.

## Elevation & Depth

Visual depth is expressed through soft, organic layering rather than sharp, heavy drop shadows:

- **Surface Tiers:**
  - **Level 0 (Base Canvas):** Warm Ivory (`#FAF7F0`) anchors background viewport areas.
  - **Level 1 (Default Content Cards):** Pure White (`#FFFFFF`) cards layered with an ultra-soft tinted shadow (`box-shadow: 0 2px 10px rgba(23, 33, 28, 0.04)`), paired with a 1px border (`#E2E8E2`).
  - **Level 2 (Active Cards & Floating Menus):** Pure White (`#FFFFFF`) with `box-shadow: 0 8px 24px rgba(13, 81, 59, 0.08)`.
  - **Level 3 (Modal Bottom Sheets):** Tonal elevation backed by a 40% opacity neutral dark scrim.
- **Tonal Indicators:** Stat indicators and icon containers rely on flat, tinted background fills (e.g., `#EAF1E9` or `#FDF5E6`) to signify grouped information without elevation complexity.

## Shapes

The design system employs a **Rounded (Level 2)** shape logic:

- **Base Corner Radius (0.5rem / 8px):** Applied to badges, metric tiles, and compact interaction surfaces.
- **Card Radius (1rem / 16px):** Standard across contact rows, reminder notifications, search inputs, and modal sheets.
- **Hero & Large Containers (1.5rem / 24px):** Used on bottom sheets and the curved lower bounds of the green dashboard header.
- **Interactive Pills (`rounded-full`):** Reserved for language toggles (`EN | हिन्दी`), status chips, and circular contact avatars.

## Components

### Buttons
- **Primary Action (e.g., "Scan Card"):** Rich Forest Green (`#0D513B`) background, white text (`#FFFFFF`), 16px corner radius, with an integrated icon slot and prominent chevron indicator. Minimum height is 56px to guarantee comfortable single-handed thumb operation.
- **Secondary Button:** Surface Sage (`#EAF1E9`) background with Forest Green text (`#0D513B`), 12px radius, no border.
- **Text Action Buttons:** Minimal padding with bold 14px typography and arrow markers (e.g., "See all >").

### Input Fields & Search
- **Search Bar:** Elevated or surface container in pure white (`#FFFFFF`) with 16px rounded corners, neutral placeholder text (`#58675F`), and an embedded primary search glyph.
- **Form Inputs (OCR Review & Edit):** 12px rounded borders in `#E2E8E2`. On focus, shifts to a 1.5px stroke of `#0D513B`. Low-confidence OCR fields receive an amber accent border (`#E6A23A`) and a subtle helper pill to guide verification.

### Cards & Contact Rows
- **Contact Card:** White card base, 16px radius, containing a 48px circular avatar or company mark on the left, primary name in `title-md`, secondary business title in `body-md`, and optional company motto/tagline with small contextual category icons.
- **Follow-up / Reminder Card:** Features a soft saffron container block (`#FDF5E6`) housing an icon, accompanied by title, date/time chips, and a right-aligned navigation chevron.
- **Metrics Summary Tiles:** Paired dual-column cards showing key metrics (e.g., total cards, monthly additions) with color-coded 40px rounded icon badges.

### Chips & Badges
- **Language Switcher:** Pill-shaped translucent dark container on hero green with white stroke/text (`EN | हिन्दी`), allowing seamless bilingual toggling.
- **Status & Category Chips:** Sage green (`#EAF1E9`) with primary green text (`#0D513B`) for verified statuses; light saffron (`#FDF5E6`) for follow-up reminders.

### Bottom Navigation
- Anchored at bottom with 64px height on warm white (`#FFFFFF`), featuring 4 key destinations: *Home*, *Cards*, *Reminders*, *Profile*. Selected state is indicated by `#0D513B` icon and label with a subtle active dot or container pill.