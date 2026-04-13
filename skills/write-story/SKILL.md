---
name: write-story
description: Converts a brief feature description into a Jira-ready user story with title, user story, acceptance criteria, and dev notes. Use when you need to write a ticket fast.
argument-hint: <brief feature description>
context: fork
---

Convert the following into a well-structured user story: $ARGUMENTS

Use this format exactly:

**Title:** [Action verb + outcome — e.g. "Reset password via email link"]

**User story:**
As a [user type],
I want to [action],
So that [outcome/benefit].

**Acceptance criteria:**
- [ ] [Specific, testable condition]
- [ ] [Specific, testable condition]
- [ ] [Add as many as needed]

**Dev notes:**
- [Edge cases, states, technical constraints, or dependencies worth flagging]
- [Anything the engineer needs to know that isn't obvious from the AC]

**Open questions:**
- [Flag anything ambiguous that needs a decision before build]

Rules:
- Write from the user's perspective, not the system's
- AC should be testable — avoid vague language like "works correctly"
- Keep dev notes engineering-relevant, not design-relevant
- If $ARGUMENTS is vague, make reasonable assumptions and flag them in Open questions
