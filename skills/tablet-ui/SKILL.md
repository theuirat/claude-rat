---
name: tablet-ui
description: >
  Use this skill whenever implementing, reviewing, or translating Figma designs
  for tablet (iPad) screens in the SafetyCulture Shared Devices project. Triggers
  on: any mention of tablet layout, iPad screen, touch target, thumb zone,
  orientation handling, sidebar navigation, split view, kiosk mode, or shared
  device UI. ALWAYS consult this skill before writing any tablet screen component,
  layout container, navigation element, or interactive touch target.
---

# tablet-ui — Tablet UI Implementation Skill

## Section 1 — The Tablet Mental Model

A tablet is not a big phone. It is not a small laptop. It is a third device category with its own biomechanics, interaction model, and user psychology.

The four physical postures that define tablet interaction (photographically confirmed across SafetyCulture customer contexts, Figma node 1056:10555):

1. **Two-hand hold, portrait (dominant for SafetyCulture FLWs)** — device held portrait in both hands, both thumbs operating the screen. Confirmed across warehouse forklift inspection (blue ruggedized case, Aetherworks), food-service environments (green ruggedized case), and office/QA contexts (black ruggedized case). Most common when standing or moving. Thumb reach is limited to center and lower-center of screen. Top corners require grip repositioning.
2. **One-hand hold + index finger** — device cradled in one arm, index finger navigating rather than thumb. Observed in hospitality context (holding device portrait, pointing at screen with index). Index finger has a smaller, more precise contact patch than a thumb — it is NOT a forgiving surface; targets still need minimum 56pt for reliable tap registration.
3. **One-hand hold + dominant thumb** — device cradled in one arm (common with ruggedized Zebra hardware), single thumb doing all the work. Creates a hard asymmetric reach limit — the reachable zone is a diagonal from bottom-opposite-corner toward center. Top of screen is inaccessible without shifting grip.
4. **Flat on surface / lying down** — device placed face-up on a bench or table, user reaching from above with index finger. Confirmed in hospitality/food-service pre-start check context (outdoor bench, green ruggedized case). User posture is standing or leaning over device. This is a DISTINCT interaction model from kiosk — the device is on a shared surface, not mounted; it is moved and shared between users. Interaction is index-fingertip taps with a downward press angle, not a side-on thumb sweep.

**Lean-back vs lean-forward** — lean-back (consumption: reading, reviewing) tolerates passive layouts and longer scroll. Lean-forward (creation: forms, input, sign-off) demands responsive targets, minimal scrolling, immediate feedback.

**The SafetyCulture Shared Devices context:** The device travels with the worker. Redpath miners carry it through underground drives. Glencore workers do pre-start checks walking around equipment. Warehouse workers move between zones. This is **not a kiosk** — the interaction model is overwhelmingly hand-held or lying flat on a shared surface. Default posture: two-hand portrait hold, thumbs operating from the sides (photographically confirmed). In-cab deployments (mining vehicles, forklifts) are landscape in a cradle. Gloved hands are common in industrial and food-service environments. Sessions are short due to **time pressure** (the worker needs to get back to physical work), not because they are approaching a terminal.

**Photographic evidence (Figma 1056:10555):** Across warehouse (forklift pre-start), hospitality (start-of-day cleaning), and office (QA planning) contexts, portrait orientation is universal. Ruggedized cases (blue, green, black depending on environment) are the norm — they add grip thickness and slightly increase the two-hand distance. In food-service, the flat-on-surface pattern with overhead index finger is confirmed. PIN entry is observed as a common authentication/input interaction.

---

## Section 2 — Touch Target & Spacing Laws

These are hard constraints, not guidelines.

| Rule | Value |
|---|---|
| Minimum tap target (iOS HIG absolute floor) | 44×44pt |
| Minimum tap target for hand-held FLW use | 56×56pt |
| Minimum tap target for gloved-hand environments | 64×64pt |
| Recommended tap target for primary CTAs | 72×72pt |
| Minimum spacing between adjacent interactive elements | 8pt |
| Recommended spacing between adjacent interactive elements | 16pt |
| Minimum form input field height | 52pt |

**Design for thumb reach, not extended fingers.** Extended-finger use is a secondary mode for surface-propped or docked devices. For hand-held use, thumbs are the primary pointer. Place primary actions **bottom-center to mid-center**. Nothing critical in the top corners — both thumbs must leave their resting position to reach there.

**Thumb reach zones (two-hand held portrait):**
- **Safe zone** — horizontal center strip from ~30% to ~70% of screen height. Both thumbs reach here without grip shift.
- **Stretch zone** — upper-center, reachable with deliberate grip adjustment.
- **Dead zone** — top corners and far lower corners. Primary actions placed here will be systematically missed.

**One-hand hold (ruggedized hardware):** the reachable zone is a diagonal from bottom-opposite-corner toward center. Top of screen is a full dead zone. Design flows that can be completed one-handed if target hardware is Zebra or similar.

**Index finger interaction (observed in hospitality and flat-on-surface contexts):** index finger has a smaller, more precise contact patch than a thumb — approximately 8–12mm vs 20–25mm for thumb. However, this does NOT mean targets can be smaller. In flat-on-surface posture, the contact angle is near-vertical (pressing downward) which concentrates the touch point — 44pt targets can register correctly. But workers move quickly and aim loosely under time pressure. Keep minimum 56pt. The benefit of index-finger mode is slightly higher precision, which means dense PIN pads and small-form input fields are more tolerable than in thumb-only contexts.

**Gloved hands:** capacitive screens vary in glove response — some ruggedized hardware has glove-mode settings. For industrial/food-service contexts assume a contact patch 2–3× larger than a bare fingertip. 44pt targets produce systematic rage-taps. Never go below 56pt for these environments.

**Fat-finger error zones:** bottom-left and bottom-right corners on large iPads accumulate accidental palm-rest touches. The iOS home indicator occupies the bottom — a fixed bottom bar must account for this.

---

## Section 3 — Orientation Strategy

**Portrait-first, not portrait-only.**

Portrait is the dominant hand-held orientation for FLWs on foot — **photographically confirmed across warehouse, food-service, and office contexts** (Figma 1056:10555). This is not an assumption; it is observed behavior across diverse industries and ruggedized form factors. But orientation is not fixed — in-cab deployments (vehicle cradles, forklift mounts) are landscape as standard. Allow deployment configuration to lock orientation via MDM rather than hard-coding it in the app.

**What must reflow on rotation:**
- Text columns
- Form layouts
- Grid columns (2-col portrait → 3-col landscape)
- Modal heights

**What must NOT change on rotation:**
- Navigation structure
- Primary CTA position relative to visible area
- Session state and any data the user has entered

**Both orientations must surface the primary CTA above the fold.** Never let rotation push the key action off-screen. Portrait and landscape are both valid deployment modes — validate both.

Navigation elements must stay in the same conceptual location across orientations. If the back button is top-left in portrait, it is top-left in landscape. Workers do not re-learn layouts mid-inspection.

---

## Section 4 — Navigation Patterns for Tablet

**iPad ≥ 11 inch: sidebar (NavigationSplitView / UISplitViewController), not a tab bar.**

A tab bar on iPad Pro wastes the left column, compresses labels, and looks like a scaled-up phone app. Apple's own apps use sidebar nav on iPad for this reason.

| Scenario | Pattern |
|---|---|
| iPad Pro 12.9 / 13 inch, regular width | Sidebar (always visible landscape, collapsible portrait) |
| iPad Pro 11 inch / iPad Air | Sidebar |
| iPad mini | Tab bar acceptable |
| Any iPad in split-view compact pane | Tab bar acceptable |
| SafetyCulture FLW flow (check-in, inspection, sign-off) | Linear full-screen flow — see below |

**For SafetyCulture FLW context:** the session flow is linear (check-in → task → sign-off). A persistent sidebar or tab bar may not apply. Use a full-screen step flow with a clear step indicator and a persistent back/cancel affordance. No nav chrome that persists between a new user's session and the previous one.

**Navigation labels are mandatory.** Icon-only nav is a mobile compromise. Tablets have the space — show label and icon at all times.

**Back navigation:** always provide both a swipe-back gesture AND a visible back button. Gesture-only back fails with gloved hands and users unfamiliar with iOS.

**Never use swipe-from-edge for custom navigation.** System gestures own those edges (back swipe, Control Center, Stage Manager). Conflicting causes navigation failures.

---

## Section 5 — Layout & Grid System

Base grid: **8pt**. All spacing, sizing, and layout values must be multiples of 8 (or 4 for micro-spacing).

| Device | Content max-width | Horizontal margins | Columns (portrait) | Columns (landscape) |
|---|---|---|---|---|
| iPad Pro 12.9 / 13 inch | 960pt | 32pt | 2 | 3 |
| iPad Pro 11 inch / iPad Air | 768pt | 24pt | 2 | 3 |
| iPad mini | 600pt | 16pt | 1–2 | 2 |

**Never stretch a single-column mobile layout to full iPad width.** A full-width text block on 12.9 inch hits 130+ characters per line — unreadable. Apply max-width constraints. Content max-width is a ceiling, not a suggestion.

**Card components:** use max-width constraint and horizontal centering on large canvases. A 400pt card looks intentional; the same card at 960pt looks broken.

**Safe area insets:** always account for `safeAreaInsets`. Home indicator and any connected keyboard consume safe area. Use `safeAreaLayoutGuide` / `ignoresSafeArea` deliberately — never clip interactive content into the safe area.

**Size classes (for split view and Stage Manager):**
- `horizontalSizeClass == .regular` → sidebar nav, multi-column layout
- `horizontalSizeClass == .compact` → single column, tab bar
- Never hard-code layout by device model — use size class

---

## Section 6 — Typography Scaling

| Style | Size | Weight | Notes |
|---|---|---|---|
| H1 / Page title | 28pt | Semibold | Max 1 per screen |
| H2 / Section header | 22pt | Semibold | |
| H3 / Card header | 18pt | Medium | |
| Body | 16pt | Regular | Minimum — never 14pt on tablet |
| Caption / Secondary | 13pt | Regular | Use sparingly |
| CTA / Button label | 17pt | Semibold | |

**Line length:** 60–75 characters. Enforce with column max-width constraints. Beyond 80 characters, reading comprehension drops measurably.

**Dynamic Type:** support it. Test at `Accessibility Large` and `AX5`. Text must not clip, overlap, or cause layout breaks. Use `UIFont.preferredFont(forTextStyle:)` — never hard-code point values in components that contain user-generated text.

**For shared device deployments:** do not rely on the user having configured their accessibility text size. MDM commonly sets a fixed system text size. Use the 16pt body minimum unconditionally.

---

## Section 7 — Gesture Design

**Supported and expected:**

| Gesture | Use |
|---|---|
| Tap | Primary interaction — must always work |
| Long press | Secondary actions, context menus |
| Swipe (directional) | List item actions, pagination |
| Pinch-to-zoom | Maps, images, documents |
| Drag-and-drop | Reordering, cross-app (iPad-exclusive) |
| Two-finger scroll | Always active in scroll containers |

**System gesture conflicts — never use these edges for custom nav:**
- Swipe from left edge → system back / sidebar
- Swipe from right edge → slide-over panel
- Swipe from bottom edge → home / app switcher
- Swipe from top edge → Notification Center / Control Center

**For SafetyCulture FLW context:** assume the user may be wearing gloves, may be unfamiliar with iOS conventions, will not read a gesture tutorial, and is operating under time pressure. Reduce the gesture vocabulary to tap, scroll, and swipe-to-dismiss. Every action achievable by tap must be achievable by tap. Long press is acceptable for secondary actions only. Complex multi-finger gestures are prohibited.

---

## Section 8 — Shared Device / FLW Rules

**Highest-priority section. When in doubt, these rules win.**

### Physical context
- Device is **hand-held**, not mounted — do not design for a fixed-angle stationary screen
- Primary hold: two-hand portrait, thumbs operating from sides (see Section 2)
- Secondary hold: one-hand with dominant thumb, common on ruggedized hardware
- Sessions are short due to **time pressure**, not kiosk proximity
- Each session is potentially a different user — no persistent personal state
- Gloved hands in industrial and food-service environments — see Section 2 target sizing
- Variable environments: warehouses, outdoor sites, underground, vehicle cabs

### Identity & session state
- **Persistent current-user display is mandatory.** Who is logged in must be visible at all times — not just at login. Workers will not spontaneously check their login state. They will complete a full inspection attributed to the wrong person before discovering the error at the signature field. This is a privacy violation and a functional defect.
- On session end / timeout: return to home state gracefully. Never show a disruptive error screen.
- **Clear all PII from the previous session** before displaying the idle/home state. Names, avatars, task history, form input — gone. Privacy by default is not a feature; it's a functional requirement because the next worker must start clean.

### Layout
- Primary CTA must be **visible without scrolling**. Above the fold is a hard requirement.
- If the primary action is below the fold, redesign the screen.
- Single action per screen where possible. Decision fatigue under time pressure causes errors.
- No hover states. Tablets have no cursor. Hover-to-reveal interactions are invisible.

### Inputs
- Form inputs: minimum 52pt height
- Trigger the native keyboard — never substitute a custom keyboard unless the input genuinely requires it (e.g., numeric PIN pad)
- Auto-advance focus after fixed-length field completion (e.g., employee ID)
- Persistent visible labels — placeholder text disappears on input and cannot be relied on

### Accessibility
- **Contrast ratio: WCAG AA minimum — 4.5:1 for normal text, 3:1 for large text.** Shared environments have variable lighting: warehouse fluorescent, outdoor glare, low-light cabs.
- Touch targets: 56pt minimum; 64pt for gloved environments (see Section 2)
- Never rely on color alone to convey status — add an icon or label

### Offline behavior (critical — not optional)
- Connectivity cannot be assumed. Underground mines, remote sites, and in-cab environments have weak or no signal.
- The app must function offline for all primary FLW tasks. Data collection that requires a live connection is a deployment blocker.
- Sync state must be visible and unambiguous — the worker must know whether their submission has reached the server. A silent failure is worse than an explicit error.
- Sync queue management (Fast User Switching, Sync Tax, Weak Signal Limbo) must be designed into the flow — not bolted on after implementation.

---

## Section 9 — Figma-to-Code Translation Rules

**Identifying a tablet frame:**
- `1024×1366` or `1366×1024` → iPad Pro 12.9 inch
- `834×1194` or `1194×834` → iPad Pro 11 inch / iPad Air
- `768×1024` → iPad (9th gen)

**Layout translation:**
- Map Figma Auto Layout directly to SwiftUI `HStack`/`VStack` with `.spacing()` and `.padding()`, or UIKit `UIStackView` with `spacing` and `layoutMargins`
- Respect Figma spacing tokens exactly — do not eyeball padding
- Figma padding values that are not multiples of 8: flag as a spec error before implementing

**Component rules:**
- Any Figma component named `Card`, `List Item`, `Row`, `Cell`, or `Tile` must have a minimum 56×56pt touch surface — add a transparent tap overlay if the visual is smaller
- Buttons with Figma height < 44pt: implement at 44pt minimum, center content vertically
- Any layer with `opacity: 0` that has an interaction defined must receive a proper `accessibilityLabel` and `accessibilityHint`

**When Figma is silent:**
- Gaps between components → default 16pt
- Column count → Section 5 defaults for target device
- Max content width → Section 5 constraints
- Typography not specified → Section 6 hierarchy
- Navigation structure → Section 4 rules for device size

**Color and contrast:** if a Figma color pairing is not verifiably WCAG AA compliant, flag it before implementing. Do not assume the designer checked it.

---

## Section 10 — Anti-Patterns

Things that look fine on mobile, look fine in Figma, and break on iPad in production:

- **Single-column layout stretched to full iPad width** — line lengths exceed 80 characters
- **Tab bar as primary nav on iPad Pro** — wastes the left column, looks like a scaled-up phone app
- **44pt tap targets for hand-held FLW use** — produces systematic miss-taps; use 56pt minimum
- **Designing for a stationary kiosk user** — SafetyCulture devices are hand-held; arm-extended extended-finger assumptions produce wrong layout priorities
- **Primary actions in top corners** — unreachable on two-hand hold without grip repositioning
- **Hamburger menu hiding primary navigation** — on 1024pt+ width, there is no justification for a nav drawer
- **Hover-dependent tooltips or content reveal** — invisible on any touch device
- **Portrait-only without landscape validation** — in-cab deployments are landscape; size class changes to compact in split view
- **Fixed bottom bars overlapping the iOS home indicator** — bottom 34pt is reserved; use `safeAreaInsets.bottom`
- **Text wider than 80 characters without column constraints** — full-width text on iPad Pro 13 inch = ~130 chars per line
- **Custom keyboards or input widgets** — breaks accessibility, autocomplete, and password managers
- **Placeholder text substituting for labels** — disappears on input; kiosk forms must have persistent visible labels
- **Session state bleeding between users** — previous user's name, data, or submissions visible to the next user is a privacy defect
- **Silent sync failures** — the worker must know whether their data reached the server; assume connectivity is unreliable
- **Animations that cannot be interrupted** — non-interruptible transitions on time-pressured FLW flows cause perceived freezes and repeated taps
