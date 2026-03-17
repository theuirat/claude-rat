# Skills

Skills are invoked with `/skill-name <arguments>` in Claude Code. They run in a forked context — the conversation branches, the skill runs, and returns output without polluting the main conversation.

---

## Design

### `write-story`
**Invoke:** `/write-story <brief feature description>`

Converts a one-liner into a Jira-ready user story. Output includes: title, user story statement, acceptance criteria, and dev notes.

**Use when:** You need to write a ticket fast and don't want to format it manually.

---

### `design-critique`
**Invoke:** `/design-critique <describe the design, flow, or paste a Figma URL>`

Runs a structured critique from the perspective of a Principal UX/UI Designer. Flags specific issues, asks sharp questions, suggests improvements. No vague praise.

**Use when:** Before presenting work, during self-review, or when you want a second opinion without pulling someone into a meeting.

---

### `research-synthesis`
**Invoke:** `/research-synthesis <paste raw notes, quotes, or observations>`

Takes unstructured research input (interview notes, Dovetail exports, Gong transcripts, site visit observations) and synthesises it into themes, insights, and design implications.

**Use when:** After user interviews, usability tests, or stakeholder interviews when you need to move from raw data to actionable direction fast.

---

### `figma-audit`
**Invoke:** `/figma-audit <Figma URL or describe the screen/component>`

Audits a Figma design for design system consistency — tokens, spacing, component usage, visual quality.

**Use when:** Before a design handoff or design review to catch inconsistencies.

---

### `heuristic-audit`
**Invoke:** `/heuristic-audit <describe the UI, flow, or paste a URL>`

Evaluates a UI against Nielsen's 10 usability heuristics. Produces a scored report with specific issues and severity ratings.

**Use when:** Competitor analysis, evaluating a new feature before shipping, or auditing an existing flow for improvement opportunities.

---

### `accessibility-check`
**Invoke:** `/accessibility-check <describe the component or screen, or paste a Figma URL>`

Reviews a design or component for WCAG 2.1 AA issues — contrast ratios, focus management, touch targets, label coverage, reading order.

**Use when:** Before any design handoff. Non-negotiable for SC work.

---

### `handoff-spec`
**Invoke:** `/handoff-spec <describe the component or flow>`

Generates a complete developer handoff spec: all states, interactions, measurements, edge cases, content rules, and behaviour notes.

**Use when:** Handing work to engineering and want to document it properly without writing it manually.

---

### `design-rationale`
**Invoke:** `/design-rationale <describe the design decision you made>`

Structures a design decision into a clear rationale document: problem, options considered, decision made, trade-offs, open questions.

**Use when:** Before a stakeholder review, or when documenting decisions in Confluence so future you (or the team) understands why something was done.

---

### `brief`
**Invoke:** `/brief <rough description of the feature or problem>`

Turns a rough PM ask or product idea into a structured design brief: problem statement, target users, goals, constraints, success metrics.

**Use when:** At the start of any new piece of work before diving into design.

---

### `okr-connect`
**Invoke:** `/okr-connect <describe the design decision or feature>`

Articulates how a design decision or feature connects to team and company OKRs. Written for a VP/CPO audience.

**Use when:** Preparing for stakeholder presentations or justifying design direction to leadership.

---

### `startmate`
**Invoke:** `/startmate <describe the feature, decision, or problem>`

Frames design work as a lean startup pitch — desirability, feasibility, viability. Cuts through noise, challenges assumptions, commercially aware.

**Use when:** Pressure-testing a feature before committing, or communicating direction to cross-functional stakeholders in startup language.

---

## Domain Experts

### `flw-dude`
**Invoke:** `/flw-dude <describe a design, problem, or question about FLWs>`

FLW (frontline worker) domain expert. Evaluates designs and answers questions through the lens of field research — shared devices, offline environments, shift-based workflows, fast user switching, ghost users, the Sync Tax, weak signal limbo.

**Use when:** Any design decision that touches the FLW side of the Shared Devices system. Will call out what will fail on the floor and why, backed by customer evidence (Glencore, Agnico, Redpath, Dinner Ladies, Fishbowl, Aetherworks, Royal Caribbean).

**Key vocabulary it knows:** GRS, ghost users, Sync Tax, weak signal limbo, Common Document Cache, Fast User Switching (FUS), forceauthn, signature field discovery.

---

### `admin-dude`
**Invoke:** `/admin-dude <describe a design, problem, or question about Admins>`

Admin domain expert for Shared Devices. Evaluates designs through the lens of IT and operations admin research — fleet governance, compliance accountability, HRIS integration, zero-touch provisioning, leavers workflows, enterprise-scale deployment.

**Use when:** Any design decision that touches the Admin side of the Shared Devices system. Will call out what fails at enterprise scale, backed by customer evidence (Glencore, Agnico, TransOcean, Royal Caribbean, Viking).

**Key vocabulary it knows:** GRS, ghost users, zero-touch provisioning, HRIS, MDM, leavers workflow, site scoping, token reset, bulk enrolment.

---

## Creative / Motion

### `motion-spec`
**Invoke:** `/motion-spec <describe the UI element, its states, and the emotional quality>`

Produces a precise animation specification — Framer Motion variants, GSAP timelines, timing values, easing curves, choreography notes. Numbers and decisions only. Readable in 2 minutes.

**Use when:** Before writing any animation code. Pairs with `animation-implementer` agent.

---

### `orb-architect`
**Invoke:** `/orb-architect <describe the product, target feeling, and references>`

Defines a complete AI persona — character, voice, emotional states, and how each state maps to visual and motion behaviour. The foundation for any AI product UI.

**Use when:** Before any UI or animation work begins on an AI persona/orb. Run this first.

---

### `orb-copywriter`
**Invoke:** `/orb-copywriter <list UI strings or states, or describe the persona and screens>`

Writes in-persona UI microcopy — empty states, loading messages, errors, onboarding, tooltips — in the voice of the defined Orb persona.

**Use when:** Any user-facing text that should feel like the AI is speaking. Run after `orb-architect`.

---

### `buck-illustrator`
**Invoke:** `/buck-illustrator <describe the character, its states, references, and output constraints>`

Senior Illustrator at Buck. Produces exact SVG construction specs for Soul-style ethereal blob characters — gradient anatomy, body path design, facial features, highlight placement, accessory construction.

**Use when:** Before implementing any character SVG. Developer-executable spec.

**Pipeline:** `buck-illustrator` → `buck-animator` → `creative-director-review`

---

### `buck-animator`
**Invoke:** `/buck-animator <character name, states, interaction triggers, tech stack>`

Senior Character Animator at Buck. Produces a tight animation decision sheet — timing values, easing choices, state behaviours, interaction rules. Max 1 page.

**Use when:** After `buck-illustrator`, before implementation. Run once the visual spec exists.

**Pipeline:** `buck-illustrator` → `buck-animator` → `creative-director-review`

---

### `creative-director-review`
**Invoke:** `/creative-director-review <paste SVG/component code + describe the reference and brief>`

Senior Creative Director at Buck. Reviews SVG/React character implementation against reference images and the creative brief. Outputs **APPROVED** or **REVISION NEEDED** with annotated redlines on every element.

**Use when:** After implementing a character component. Drives the iteration loop until the work is production-ready.

**Pipeline:** `buck-illustrator` → `buck-animator` → `creative-director-review`
