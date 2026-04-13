---
name: heuristic-audit
description: Evaluates a UI against Nielsen's 10 usability heuristics. Produces a scored report with specific issues and recommendations. Use for competitor analysis, design reviews, or evaluating new features.
argument-hint: <describe the UI, flow, or paste a URL>
context: fork
allowed-tools: WebFetch
---

Run a heuristic evaluation on the following: $ARGUMENTS

If a URL is provided, fetch it first. Act as a Principal UX Designer conducting a formal usability review.

Score each heuristic: ✅ Pass | ⚠️ Minor issue | ❌ Major issue

---

**1. Visibility of system status** [score]
- [Observation and specific example]

**2. Match between system and real world** [score]
- [Observation and specific example]

**3. User control and freedom** [score]
- [Observation and specific example]

**4. Consistency and standards** [score]
- [Observation and specific example]

**5. Error prevention** [score]
- [Observation and specific example]

**6. Recognition rather than recall** [score]
- [Observation and specific example]

**7. Flexibility and efficiency of use** [score]
- [Observation and specific example]

**8. Aesthetic and minimalist design** [score]
- [Observation and specific example]

**9. Help users recognise, diagnose, and recover from errors** [score]
- [Observation and specific example]

**10. Help and documentation** [score]
- [Observation and specific example]

---

**Overall score:** [X/10 heuristics passing]

**Top 3 issues to fix (by severity):**
1. [Issue — heuristic it violates — recommended fix]
2. [Issue — heuristic it violates — recommended fix]
3. [Issue — heuristic it violates — recommended fix]
