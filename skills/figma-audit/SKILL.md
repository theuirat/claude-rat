---
name: figma-audit
description: Audits a Figma design for consistency with design system tokens, spacing, component usage, and visual quality. Use before handoff or design reviews.
argument-hint: <Figma URL or describe the screen/component>
context: fork
allowed-tools: WebFetch
---

Audit the following design: $ARGUMENTS

If a Figma URL is provided, use the Figma MCP (get_design_context, get_variable_defs, get_screenshot) to pull the design first.

Act as a Senior Designer doing a pre-handoff quality check. Be specific and reference exact elements.

Structure your audit as:

**Design system compliance:**
- [ ] Colours — using tokens, not hardcoded hex values
- [ ] Typography — using defined type styles, not custom sizes
- [ ] Spacing — aligned to spacing scale (4/8/12/16/24/32...)
- [ ] Components — using library components, not detached copies
- [ ] Border radius — consistent with system values
- Issues found: [list specific violations with element names]

**Layout & structure:**
- [ ] Grid alignment
- [ ] Consistent padding/margins across similar elements
- [ ] Proper component hierarchy
- Issues found: [list specifics]

**States & edge cases:**
- [ ] Empty state handled
- [ ] Error state handled
- [ ] Loading state handled
- [ ] Long text / overflow handled
- [ ] Mobile/responsive considered
- Missing states: [list what's not covered]

**Visual quality:**
- [ ] Hierarchy is clear — one obvious focal point per screen
- [ ] Contrast is sufficient
- [ ] Icon sizes are consistent
- Issues found: [list specifics]

**Ready for handoff?**
- [Yes / No / Yes with caveats]
- [Blockers that must be fixed before handoff]
- [Nice-to-haves that can be addressed after]
