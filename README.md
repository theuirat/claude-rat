# Claude Skills & Agents

Personal Claude Code setup — skills (invokable with `/skill-name`) and agents (autonomous subprocesses). Built for a Senior Product Designer workflow at SafetyCulture and across personal projects.

---

## Quick Reference

### Skills

| Skill | Invoke | One-liner |
|---|---|---|
| `write-story` | `/write-story <feature description>` | Converts a brief into a Jira-ready user story |
| `design-critique` | `/design-critique <design or Figma URL>` | Structured critique from a Principal UX perspective |
| `research-synthesis` | `/research-synthesis <raw notes/quotes>` | Turns raw research into themes, insights, implications |
| `figma-audit` | `/figma-audit <Figma URL>` | Audits design for token/spacing/component consistency |
| `heuristic-audit` | `/heuristic-audit <UI or URL>` | Nielsen's 10 heuristics scored report |
| `accessibility-check` | `/accessibility-check <component or screen>` | WCAG 2.1 AA review |
| `handoff-spec` | `/handoff-spec <component or flow>` | Developer handoff spec — states, measurements, edge cases |
| `design-rationale` | `/design-rationale <design decision>` | Structured rationale doc for Confluence or stakeholder review |
| `brief` | `/brief <rough idea or PM ask>` | Structured design brief from a rough description |
| `okr-connect` | `/okr-connect <design decision or feature>` | Links design work to team/company OKRs |
| `startmate` | `/startmate <feature or decision>` | Frames work as a lean startup pitch (desirability/feasibility/viability) |
| `motion-spec` | `/motion-spec <UI element and states>` | Precise animation spec (Framer Motion/GSAP) before writing code |
| `orb-architect` | `/orb-architect <product and feeling>` | Defines an AI persona — character, voice, emotional states |
| `orb-copywriter` | `/orb-copywriter <UI states or screens>` | In-persona UI microcopy for AI products |
| `buck-illustrator` | `/buck-illustrator <character description>` | SVG construction spec for Soul-style blob characters |
| `buck-animator` | `/buck-animator <character and states>` | Animation decision sheet for Soul-style characters |
| `creative-director-review` | `/creative-director-review <SVG/component + brief>` | CD-level review of character implementation — APPROVED or REVISION NEEDED |

### Agents

| Agent | Trigger | One-liner |
|---|---|---|
| `story-template-writer` | "Create a story for…" | Writes a structured story doc from a feature description |
| `scrum-master` | "Turn this PRD/spec into stories" | Converts requirements docs into implementation-ready story files |
| `story-implementer` | "Implement the [story].md story" | Reads an Approved story and executes it end-to-end |
| `qa-validator` | Story moves to Review status | Validates implementation against acceptance criteria |
| `kanban-manager` | "Monday lfg" / weekly board sync | Runs Jira board check-in, suggests card movements |
| `usability-heuristics-evaluator` | "Evaluate [URL] for usability issues" | Full heuristic evaluation of a live UI or screenshots |
| `animation-implementer` | "Implement the motion spec" | Builds animated components from a motion spec |

---

## Detailed Docs

- [Skills](docs/skills.md)
- [Agents](docs/agents.md)
- [Workflows — how they chain together](docs/workflows.md)
