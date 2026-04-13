---
name: handoff-spec
description: Generates a developer handoff spec for a component or flow — states, interactions, measurements, edge cases, and content rules. Use when preparing designs for engineering.
argument-hint: <describe the component or flow>
context: fork
disable-model-invocation: true
---

Write a developer handoff spec for the following: $ARGUMENTS

Act as a Senior Designer writing clear, unambiguous specs for an engineer who won't be in the room to ask questions.

Structure:

**Component / Feature:** [Name]

**Overview:**
- [1–2 sentences on what this is and what it does]

**States:**
| State | Description | Visual change |
|---|---|---|
| Default | | |
| Hover | | |
| Focus | | |
| Active / Pressed | | |
| Disabled | | |
| Loading | | |
| Error | | |
| Success/Empty | | |
[Remove rows that don't apply. Add any custom states.]

**Interactions & behaviour:**
- [Trigger] → [Response] — [Timing/animation if applicable]
- [Repeat for each interaction]

**Measurements:**
- Height: [value]
- Padding: [top right bottom left]
- Gap between elements: [value]
- Border radius: [value]
- Font: [size / weight / line-height]
- Icon size: [value]

**Content rules:**
- [Character limits, truncation behaviour, placeholder text]
- [What happens with long strings / empty states]

**Edge cases:**
- [What happens when X goes wrong]
- [Behaviour on small screens]
- [Behaviour with no data / zero state]

**Dependencies:**
- [Design tokens, components, or APIs this relies on]

**Figma link:** [Add URL]
