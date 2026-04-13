---
name: accessibility-check
description: Reviews a design or component for WCAG 2.1 AA accessibility issues — contrast, focus, touch targets, labels, reading order. Use before any handoff.
argument-hint: <describe the component or screen, or paste a Figma URL>
context: fork
allowed-tools: WebFetch
---

Run an accessibility review on the following: $ARGUMENTS

If a Figma URL is provided, use the Figma MCP to pull the design. Act as an accessibility specialist reviewing against WCAG 2.1 AA as a minimum standard.

Structure:

**Colour & contrast:**
- [ ] Text contrast ratio ≥ 4.5:1 (normal text) / 3:1 (large text)
- [ ] UI component contrast ≥ 3:1 against adjacent colours
- [ ] No information conveyed by colour alone
- Issues: [list with specific elements and approximate ratios]

**Focus & keyboard:**
- [ ] All interactive elements are keyboard accessible
- [ ] Focus order is logical (matches visual/reading order)
- [ ] Focus indicator is visible
- [ ] No keyboard traps
- Issues: [list specifics]

**Touch targets:**
- [ ] Minimum 44×44px touch target for all interactive elements
- [ ] Sufficient spacing between adjacent targets
- Issues: [list specifics]

**Labels & semantics:**
- [ ] All form fields have visible labels (not just placeholder text)
- [ ] Icons and buttons have accessible labels
- [ ] Images have meaningful alt text (or are marked decorative)
- [ ] Headings create a logical hierarchy
- Issues: [list specifics]

**Motion & timing:**
- [ ] Animations can be disabled / respect prefers-reduced-motion
- [ ] No flashing content (>3 flashes/sec)
- Issues: [list specifics]

**Summary:**
- WCAG 2.1 AA: [Pass / Fail / Partial]
- Blockers (must fix): [list]
- Recommendations (should fix): [list]
