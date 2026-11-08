---
name: JemberGo Design System
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3f4850'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#707881'
  outline-variant: '#bfc7d2'
  surface-tint: '#006398'
  primary: '#006194'
  on-primary: '#ffffff'
  primary-container: '#007bb9'
  on-primary-container: '#fdfcff'
  inverse-primary: '#93ccff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#b90538'
  on-tertiary: '#ffffff'
  tertiary-container: '#dc2c4f'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cce5ff'
  primary-fixed-dim: '#93ccff'
  on-primary-fixed: '#001d31'
  on-primary-fixed-variant: '#004b73'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdadb'
  tertiary-fixed-dim: '#ffb2b7'
  on-tertiary-fixed: '#40000d'
  on-tertiary-fixed-variant: '#92002a'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  display-hero:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '800'
    lineHeight: 44px
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-2xs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
  space-2xl: 3rem
---

## Brand & Style

The design system establishes an immersive, contemporary regional travel experience that bridges East Java’s coastal landscapes and volcanic highlands with modern digital booking patterns. The visual persona is vibrant, welcoming, and dependable—evoking the freedom of coastal wanderlust alongside the grounded assurance required for ticketing, transit, and route planning.

The design movement combines **Modern Tropical Editorial** with **Clean Mobile Utility**:
- **Layered Tactility:** Soft, generously rounded cards that float above crisp neutral canvases, mimicking sunlit terrain and coastal horizons.
- **Micro-Atmospheres:** Translucent glass floating chips, soft blurred underlays for media overlays, and oceanic primary gradients that convey freshness and movement.
- **Purposeful Vibrancy:** Intentional color distribution where lush botanical greens and coastal azures direct the user’s gaze, balanced by solid navy anchor typography that eliminates visual noise.

## Colors

The palette draws directly from the natural beauty of Jember—the azure breaks of Pantai Papuma and Teluk Love, the rolling tea hills of Puncak Rembangan, and golden hour coastal glows.

- **Primary (`#0284C7` / `#0EA5E9`):** Ocean Cyan-Blue. Used for dominant action buttons, active navigation states, progress meters, and key destination highlight rings.
- **Secondary (`#10B981`):** Highland Emerald. Symbolizes eco-trails, plantation tours, natural parks, success validations, and verified badges.
- **Tertiary (`#F43F5E`):** Sunset Coral. Reserved strictly for limited-availability alerts, discount tags, favorited destinations, and urgent booking prompts.
- **Neutral (`#0F172A`):** Deep Navy. Replaces harsh pitch-black to deliver rich editorial weight for headlines, high-contrast sheet backgrounds, and structural icons.
- **Canvas & Surface Tiering:**
  - `surface-canvas`: `#F8FAFC` (Clean porcelain base)
  - `surface-card`: `#FFFFFF` (Pure white for raised interactives)
  - `surface-muted`: `#F1F5F9` (Divider lines, inactive pill fills)
  - `text-secondary`: `#64748B` (Secondary guidance copy, metadata)

## Typography

The pairing between **Plus Jakarta Sans** and **Inter** bridges playful wanderlust and dense mobile legibility.

- **Plus Jakarta Sans (Headlines, Hero Banners, Dynamic Metadata):** Provides rounded geometry, warm apertures, and high display impact. It grounds scenic location names like *Pantai Papuma* and *Puncak Rembangan* with energetic warmth.
- **Inter (Body Copy, Facility Specs, Booking Logistics):** Maximizes readability in dense operational contexts such as itinerary tables, checkout breakdowns, ticket barcodes, and user reviews.
- **Hierarchy Rules:**
  - Never set body paragraphs in Plus Jakarta Sans.
  - Category labels, badges, and price indicators must always use `label-md` or `label-lg` with tight tracking to ensure instant scannability on small screens.

## Layout & Spacing

The layout is built for mobile-first thumb zones while preserving a flexible rhythm across tablet views.

- **Canvas Container Model:** 
  - Mobile screens use a fluid single-column grid bounded by `margin: 1.25rem` (20px) outer edge pads.
  - Horizontal carousels (featured destinations, curated categories) break the container edge with full-bleed scrolling offset by `margin` on entry.
- **Rhythm & Safe Areas:**
  - Vertical flow relies strictly on 4px and 8px multiples. Section transitions use `space-xl` (32px), internal card separation relies on `space-md` (16px), and tag clusters use `space-xs` (8px).
  - Bottom navigation dock requires an automated baseline padding offset of `space-2xl` (48px) plus device safe-area insets (`env(safe-area-inset-bottom)`) to guarantee cards do not get obscured.

## Elevation & Depth

Visual hierarchy uses **Ambient Marine Diffusion** rather than heavy drop shadows:

- **Level 0 (Flat Base):** Background canvas `#F8FAFC`, no shadow, zero stroke.
- **Level 1 (Surface Cards & Listing Tiles):** White surfaces resting on a soft tinted drop shadow: `0px 8px 24px -4px rgba(15, 23, 42, 0.06)`. Edge containment is augmented with a 1px hairline stroke (`rgba(15, 23, 42, 0.04)`).
- **Level 2 (Interactive Floating Elements, Date Pickers, Modals):** Medium elevation for bottom sheets, quick filter sheets, and ticket barcodes: `0px 16px 36px -8px rgba(2, 132, 199, 0.12)`.
- **Level 3 (Fixed Floating Bottom Dock & Sticky Action Bars):** Frosted glass combined with buoyant elevation: `background: rgba(255, 255, 255, 0.88)`, `backdrop-filter: blur(20px)`, and `box-shadow: 0px -4px 28px rgba(15, 23, 42, 0.08)`.

## Shapes

The design system adopts organic, friendly curvature to echo water currents, coastal coastlines, and soft topography.

- **Pill Shape (`rounded-full`):** Category search chips, primary interactive buttons, destination duration badges, and status pills.
- **Double Extra-Rounded (`rounded-2xl` / 16px - 20px):** Standard destination preview cards, facility stat blocks, review quotes, and text inputs.
- **Triple Extra-Rounded (`rounded-3xl` / 24px - 28px):** Hero featured landscape cards, ticket vouchers, modal booking sheets, and the floating bottom navigation bar container.
- **Shape Nesting Rule:** When components with `rounded-2xl` sit inside `rounded-3xl` containers, internal margin must equal or exceed 12px to preserve harmonious concentric corners.

## Components

### Buttons
- **Primary Action:** Solid gradient fill (`#0284C7` to `#0EA5E9`), pill-shaped (`rounded-full`), `label-lg` bold white typography, 52px height for prime touch ergonomics. Accompanied by a gentle cyan glow shadow on press.
- **Secondary Action:** Ghost surface with `#F0F9FF` background, `#0284C7` text label, 1px border `rgba(2, 132, 199, 0.2)`.
- **Icon Buttons (Bookmark, Back, Share):** 44x44px circular disks with white frosted glass backgrounds (`rgba(255, 255, 255, 0.85)`), backdrop blur, and dark navy iconography.

### Chips & Filter Pills
- Inactive: `#F1F5F9` background, `#64748B` typography, zero border, `rounded-full`.
- Active: Deep ocean `#0284C7` background, pure white typography, subtle drop shadow.
- Special Filter (Eco/Trek): Deep emerald `#10B981` tint when filtering botanical and highland sites like *Air Terjun Tancak*.

### Destination Cards
- **Editorial Landscape Card:** 16:10 aspect ratio image, `rounded-3xl` container, subtle top badge (e.g., "Trending di Jember"), inner bottom dark vignette gradient (`rgba(15, 23, 42, 0.8)` fade) hosting destination name in white `headline-sm`, pricing, and location indicator icon.
- **Ticket / Booking Pass Card:** Clean white `rounded-3xl` surface split by a scalloped notch divider and dashed line, featuring QR code/barcode section, departure time, and verified status badge.

### Input Fields & Search Bars
- Floating rounded search input (`rounded-full`), height 54px, `#FFFFFF` fill with Level 1 shadow, left magnifying glass icon in `#0284C7`, right mic or filter trigger icon separated by a subtle vertical stroke.

### Floating Bottom Navigation Dock
- **Layout:** Floating detached pill positioned 16px above the screen bottom margin.
- **Structure:** 5 primary tabs: *Beranda*, *Jelajahi*, *Peta*, *Tiket Saya*, *Profil*.
- **State Styling:** Active tab renders with an ocean-cyan icon, micro-indicator dot below, and bold label. Inactive tabs display in neutral muted slate (`#94A3B8`). Center tab (*Peta*) can feature a slightly elevated circular accent variant for spatial orientation.