# Agents

Agents are autonomous subprocesses launched by Claude Code. They run with their own context, tools, and memory — and return a single result when done. Unlike skills (which are prompt templates), agents can read files, write code, run tests, and chain multiple tool calls together.

Agent definition files live in [`/agents`](../agents/).

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

[→ Agent definition](../agents/story-template-writer.md)

---

### `scrum-master`
**Trigger:** "Turn this PRD/spec into stories" or "Create implementation-ready stories from [requirements doc]"

Reads a product requirements document or feature specification and converts it into one or more detailed, actionable story files. Also handles revising stories based on QA audit feedback.

**Model:** Opus (for document analysis depth)

**Use when:** You have a PRD or feature spec and need it broken into developer-ready stories. Also use when QA has flagged issues with a story and you need it revised.

[→ Agent definition](../agents/scrum-master.md)

---

### `story-implementer`
**Trigger:** "Implement the [story].md story" / "The [story] story has been approved, implement it"

Takes an **Approved** story file from `docs/stories/`, reads it, implements all tasks, writes tests, and marks the story as Review when done. Reads `CLAUDE.md` first to follow project conventions.

**Model:** Opus

**Use when:** A story has been reviewed and approved. Do not trigger on Draft or In Progress stories.

[→ Agent definition](../agents/story-implementer.md)

---

### `qa-validator`
**Trigger:** Story moves to Review status / "Validate the [story] story"

Validates a completed story implementation against its acceptance criteria and `CLAUDE.md` standards. Checks code quality, security, test coverage, and whether all ACs are met.

**Model:** Opus

**Use when:** Development is done and the story is in Review. Outputs PASS or FAIL with specific findings. If FAIL, feeds back to `story-implementer` or `scrum-master` for revision.

[→ Agent definition](../agents/qa-validator.md)

---

## Design Operations Agents

### `design-to-pr`
**Trigger:** "Can you implement FG-1234 and raise a PR?" / "Here's the ticket: [Jira URL] — can you ship it?"

Full designer shipping workflow: reads the Jira ticket, fetches the Figma design reference, finds the code, makes the minimal change, takes Playwright before/after screenshots on localhost, opens the PR with the SC body template, then hands off to `pr-monitor` for CI and review.

**Model:** Opus

**Use when:** You have a Jira ticket and want the whole flow handled end-to-end — from ticket to open PR. Pairs with `pr-monitor`.

[→ Agent definition](../agents/design-to-pr.md)

---

### `pr-monitor`
**Trigger:** "CI is failing on PR #XXXX. Can you fix it?" / "Check CI on PRs #X and #Y and fix anything broken." / "There are review comments on PR #XXXX — can you handle them?"

Manages the full lifecycle of a GitHub PR: checks CI status, reads Buildkite failures, responds to reviewer comments, applies fixes, and pushes until the PR is green and approved. Runs the full check → diagnose → fix → push loop autonomously.

**Model:** Opus

**Use when:** A PR has failing CI, unresolved reviewer comments, or needs to be shepherded to merge. Typically handed off from `design-to-pr`.

[→ Agent definition](../agents/pr-monitor.md)

---

### `kanban-manager`
**Trigger:** "Monday lfg" / "Time for my weekly board update" / "Help me update my kanban board"

Runs a weekly Jira board check-in against the UXD board. Fetches current card state, asks what you worked on last week, suggests movements, and captures new work.

**Board:** UXD project, Board ID 6974 (SafetyCulture Jira)

**Use when:** Once a week to keep the Jira board accurate. The "Monday lfg" phrase is the trigger.

[→ Agent definition](../agents/kanban-manager.md)

---

### `usability-heuristics-evaluator`
**Trigger:** "Evaluate [URL/screenshots] for usability issues" / "Audit this flow" / "Find UX problems in…"

Conducts a full heuristic evaluation against Nielsen's 10 heuristics. Produces a scored report with severity ratings, specific issues, and recommendations. Can also implement fixes.

**Model:** Opus

**Use when:** Competitor analysis, pre-ship audits, evaluating onboarding or checkout flows, or any situation where you want a systematic usability review rather than a quick opinion.

**Difference from `heuristic-audit` skill:** This agent can browse live URLs, take screenshots, and implement fixes. The skill is faster for quick evaluations without tool access.

[→ Agent definition](../agents/usability-heuristics-evaluator.md)

---

### `animation-implementer`
**Trigger:** "Implement the motion spec" / "Add entrance animations to [component]" / "Add a new state to the orb"

Implements motion design in React using Framer Motion, GSAP, and Three.js/WebGL. Reads `CLAUDE.md` first. Handles orb emotional states, message animations, state transitions, ambient effects.

**Use when:** A `motion-spec` skill output exists and needs to be turned into code. Also use for any animation work on React components — do not use `story-implementer` for animation.

**Pairs with:** `motion-spec` skill (run first), `buck-illustrator` + `buck-animator` skills (for character work).

[→ Agent definition](../agents/animation-implementer.md)
