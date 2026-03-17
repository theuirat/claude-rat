# Agents

Agents are autonomous subprocesses launched by Claude Code. They run with their own context, tools, and memory — and return a single result when done. Unlike skills (which are prompt templates), agents can read files, write code, run tests, and chain multiple tool calls together.

Agents are triggered automatically based on what you ask, or can be invoked explicitly.

---

## Development Workflow Agents

These four agents form a full story lifecycle pipeline:

```
story-template-writer → scrum-master → story-implementer → qa-validator
```

### `story-template-writer`
**Trigger:** "Create a story for [feature]"

Creates a new user story document following the established story template format. Covers new features, bug fixes, technical debt, or any task that needs structured planning.

**Output:** A `.md` story file in `docs/stories/` with title, user story statement, acceptance criteria, task breakdown, and dev notes.

**Use when:** You have a feature idea and need a properly formatted story doc before development starts.

---

### `scrum-master`
**Trigger:** "Turn this PRD/spec into stories" or "Create implementation-ready stories from [requirements doc]"

Reads a product requirements document or feature specification and converts it into one or more detailed, actionable story files. Also handles revising stories based on QA audit feedback.

**Model:** Opus (for document analysis depth)

**Use when:** You have a PRD or feature spec and need it broken into developer-ready stories. Also use when QA has flagged issues with a story and you need it revised.

---

### `story-implementer`
**Trigger:** "Implement the [story].md story" / "The [story] story has been approved, implement it"

Takes an **Approved** story file from `docs/stories/`, reads it, implements all tasks, writes tests, and marks the story as Review when done. Reads `CLAUDE.md` first to follow project conventions.

**Model:** Opus

**Use when:** A story has been reviewed and approved. Do not trigger on Draft or In Progress stories.

---

### `qa-validator`
**Trigger:** Story moves to Review status / "Validate the [story] story"

Validates a completed story implementation against its acceptance criteria and `CLAUDE.md` standards. Checks code quality, security, test coverage, and whether all ACs are met.

**Model:** Opus

**Use when:** Development is done and the story is in Review. Outputs PASS or FAIL with specific findings. If FAIL, feeds back to `story-implementer` or `scrum-master` for revision.

---

## Design Operations Agents

### `kanban-manager`
**Trigger:** "Monday lfg" / "Time for my weekly board update" / "Help me update my kanban board"

Runs a weekly Jira board check-in against the UXD board. Fetches current card state, asks what you worked on last week, suggests movements, and captures new work.

**Board:** UXD project, Board ID 6974 (SafetyCulture Jira)

**Use when:** Once a week to keep the Jira board accurate. The "Monday lfg" phrase is the trigger.

---

### `usability-heuristics-evaluator`
**Trigger:** "Evaluate [URL/screenshots] for usability issues" / "Audit this flow" / "Find UX problems in…"

Conducts a full heuristic evaluation against Nielsen's 10 heuristics. Produces a scored report with severity ratings, specific issues, and recommendations. Can also implement fixes.

**Model:** Opus

**Use when:** Competitor analysis, pre-ship audits, evaluating onboarding or checkout flows, or any situation where you want a systematic usability review rather than a quick opinion.

**Difference from `heuristic-audit` skill:** This agent can browse live URLs, take screenshots, and implement fixes. The skill is faster for quick evaluations without tool access.

---

### `animation-implementer`
**Trigger:** "Implement the motion spec" / "Add entrance animations to [component]" / "Add a new state to the orb"

Implements motion design in React using Framer Motion, GSAP, and Three.js/WebGL. Reads `CLAUDE.md` first. Handles orb emotional states, message animations, state transitions, ambient effects.

**Use when:** A `motion-spec` skill output exists and needs to be turned into code. Also use for any animation work on React components — do not use `story-implementer` for animation.

**Pairs with:** `motion-spec` skill (run first), `buck-illustrator` + `buck-animator` skills (for character work).
