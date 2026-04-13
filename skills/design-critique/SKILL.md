---
name: design-critique
description: Runs a structured critique on a design, flow, or screen. Flags issues, asks good questions, and suggests improvements. Use before presenting work or during self-review.
argument-hint: <describe the design, flow, or paste a Figma URL>
context: fork
---

Critique the following design: $ARGUMENTS

Act as a Principal UX/UI Designer giving structured feedback to a senior peer. Be direct and specific — no vague praise.

Structure your critique as:

**What's working:**
- [Specific things that are well-executed and why]

**Issues to address:**
- [Issue] — [Why it's a problem] — [Suggested fix]
- [Repeat for each issue, ordered by severity]

**Questions to pressure-test:**
- [Design decision that needs a rationale or might be challenged in review]
- [Edge case or state that hasn't been considered]

**One thing to focus on:**
- [If you could only fix one thing before presenting this, what is it?]

Rules:
- Be honest. Don't soften issues.
- Reference specific elements, not vague areas ("the CTA" not "the bottom section")
- Consider: hierarchy, clarity, consistency, edge cases, accessibility, mobile, and empty/error states
- If a Figma URL is provided and you have MCP access, pull the design first
