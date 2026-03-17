# Workflows

Common chains and sequences for using skills and agents together.

---

## Feature Development Pipeline

Full story lifecycle from idea to shipped code.

```
1. /brief <rough idea>
   → Structured design brief

2. /write-story <brief output>  (or scrum-master agent for full PRD)
   → story-template-writer agent → story doc in docs/stories/

3. Review & approve the story

4. story-implementer agent
   → Implements the story, marks as Review

5. qa-validator agent
   → Validates against ACs, marks Done (or sends back for revision)
```

---

## Design Review Pipeline

Before presenting or handing off a design.

```
1. /design-critique <Figma URL>
   → Issues and questions to address

2. /accessibility-check <component or screen>
   → WCAG 2.1 AA issues

3. /figma-audit <Figma URL>
   → Token/spacing/component consistency

4. /handoff-spec <component or flow>
   → Developer handoff doc
```

---

## Character / AI Persona Pipeline

Building an animated AI persona from scratch.

```
1. /orb-architect <product and target feeling>
   → Persona definition: character, voice, emotional states

2. /buck-illustrator <character description + references>
   → SVG construction spec

3. /buck-animator <character states + tech stack>
   → Animation decision sheet

4. animation-implementer agent
   → Implements SVG + animations in React

5. /creative-director-review <component code + reference + brief>
   → APPROVED or annotated REVISION NEEDED

   (repeat 4–5 until APPROVED)

6. /orb-copywriter <UI states and persona>
   → In-persona microcopy for all UI strings
```

---

## Research to Direction Pipeline

After user interviews or usability testing.

```
1. /research-synthesis <raw notes / Gong transcript / interview notes>
   → Themes, insights, design implications

2. /design-critique <current design against the insights>
   → What's misaligned with the research

3. /okr-connect <proposed design direction>
   → Business case for the direction
```

---

## Stakeholder Presentation Prep

```
1. /design-rationale <decision you made>
   → Structured rationale: options, decision, trade-offs

2. /okr-connect <the same decision>
   → Business/OKR framing

3. /startmate <the feature or direction>
   → Desirability / feasibility / viability pitch framing
```

---

## Weekly Board Sync

```
Every Monday:
→ "Monday lfg"
→ kanban-manager agent runs
→ Jira board updated
```

---

## Quick Audit (no Figma access)

For auditing a live product or competitor quickly.

```
1. usability-heuristics-evaluator agent <URL>
   → Full heuristic report with severity scores

   OR

1. /heuristic-audit <describe the UI or paste a URL>
   → Faster, lighter version (no tool access)
```
