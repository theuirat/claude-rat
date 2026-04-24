# Methods

Structured frameworks for running longer, more ambitious sessions with Claude Code. Unlike skills (single prompts) or agents (single workflows), methods govern how an entire project is planned and built across multiple sessions.

**The core idea:** Spec-Driven Design means using *structured methods*, not just prompts, to run longer, more ambitious sessions. Rather than asking Claude one question at a time, these methods give it a full picture of a project so it can plan, build, and verify work autonomously.

The distinction matters:

- **Vibe coding** — telling AI what to do and going with the vibe. Fast, but you're not really in control.
- **Spec-Driven Design** — AI is a coding assistant, but *you* own the end-to-end. Lots of planning, disciplined execution, and rules for both AI and yourself. You're the project manager orchestrating the process.

---

## At a glance

| Method | Full name | Role | Best for |
|---|---|---|---|
| **OpenSpec** ⭐ | OpenSpec | Change workflow | Any change — feature, fix, refactor — where you want Claude to stay accurate and on-target |
| **GSD** | Get Shit Done | Execution | Building story by story across multiple sessions without losing context |
| **BMAD** | Breakthrough Method in Agile Development | Planning | Scoping a new project from scratch — requirements, architecture, story backlog |
| **ODD** | Outcome-Driven Development | Design-first build | Projects where design quality and verified delivery matter most |

**The most common flow:** BMAD to plan → GSD to build → OpenSpec for individual changes.

---

## Which method?

| Situation | Use |
|---|---|
| Any change where you want Claude to stay accurate | **OpenSpec** ⭐ |
| Quick idea exploration before committing to a build | OpenSpec explore mode |
| Building across multiple sessions (prototype, app) | **GSD** |
| Starting from scratch with no docs yet | **BMAD** to plan → **GSD** to build |
| Design-led project where quality and verification matter most | **ODD** |
| Already have requirements, need stories for dev handoff | BMAD Product Owner → Scrum Master |

---

## OpenSpec ⭐

OpenSpec is a structured change workflow for Claude Code. Instead of asking Claude to "just build it", you first generate a full proposal — what to build, how to build it, and a checklist of tasks — before any code is written. This dramatically improves accuracy and keeps Claude on-target across long sessions.

**Best for:** Any change (feature, fix, refactor, UI update) where you want Claude to stay on-target. Especially strong for UI and prototype work where design intent needs to be captured explicitly before implementation begins.

**What makes it different:** The proposal phase forces Claude to reason through what it's building before touching files. This one step eliminates most off-track sessions and hallucinated solutions.

### Setup

**1. Install the CLI**

```shell
npm install -g @fission-ai/openspec@latest
```

Verify it's installed:

```shell
openspec --version
```

If the command isn't found, add npm global bin to PATH:

```shell
export PATH="$PATH:$(npm bin -g)"
```

**2. Set up artifact storage**

OpenSpec generates artifacts (proposals, specs, tasks) per change. Where they live depends on context:

**SC / team project** — store artifacts in the shared findings repo so the team can learn from them:

```shell
# Clone the findings repo once (SC-internal — requires access)
cd ~/projects
git clone https://github.com/SafetyCulture/openspec-findings

# From inside your project directory:
# If openspec/ already exists in the project, move it across first:
mv openspec ../openspec-findings/<your-project-name>/

# If it doesn't exist yet, create the folder:
mkdir -p ../openspec-findings/<your-project-name>/openspec

# Create a symlink so openspec still works from your project:
ln -s ../openspec-findings/<your-project-name>/openspec openspec

# Add openspec to .gitignore so it's not committed to your project repo:
echo "openspec/" >> .gitignore
```

> **Note:** The symlink is local. If you re-clone your project on a new machine, re-run the `ln -s` step.

**Personal project** — artifacts stay in the project directory. Skip the findings repo entirely:

```shell
# Nothing to do — openspec init (step 4) creates the openspec/ folder automatically
```

**3. Install the Claude Code skills**

```shell
openspec init --tools claude
```

This installs four slash commands into `.claude/skills/`. Open Claude Code and type `/` to verify:

| Command | What it does |
|---|---|
| `/openspec-explore` | Think through ideas — no code written, ever |
| `/openspec-propose` | Scaffold a full change: proposal + design + tasks |
| `/openspec-apply-change` | Implement task by task from the proposal |
| `/openspec-archive-change` | Finalise and archive when done |

If the skills don't appear, re-run `openspec init --tools claude` from inside the project directory.

### The workflow

**Clear requirement → straight to propose:**
```
/openspec-propose → review design.md → /openspec-apply-change → /openspec-archive-change
```

**Fuzzy idea → explore first:**
```
/openspec-explore → [think it through] → /openspec-propose → /openspec-apply-change → /openspec-archive-change
```

### Useful commands

```shell
# See all active changes
openspec list

# Check artifact status for a specific change
openspec status --change your-change-name
```

### Tips

- **Describe intent, not implementation.** Tell Claude what the user should experience — not which component to use.
- **Always read `design.md` before applying.** 30 seconds here saves a full re-implementation.
- **Use explore mode for UI/layout decisions.** Share a Figma link and ask Claude to map the delta before proposing.
- **Always archive.** This keeps `specs/` accurate for the next session.

### Watch out for

- **Spec drift.** If you make significant changes mid-implementation, update `design.md` directly — don't re-run `/openspec-propose` as it will overwrite your original spec.
- **Claude drifting out of explore mode.** If it starts writing code during explore, re-prompt: *"Stay in explore mode — don't write any code yet."*
- **Mid-implementation plan changes.** Edit the relevant artifact file directly rather than re-running propose.
- **A new spec folder being created when updating an existing feature.** Run `openspec list` to find the existing change name and pass it explicitly.

---

## GSD

GSD (Get Shit Done) is an execution framework built for Claude Code. It solves *context rot* — the quality degradation that happens as Claude fills its context window and starts forgetting earlier decisions.

GSD fixes this by loading four structured documents at the start of every session. Claude always knows what the project is, what's been done, what's next, and what you're doing right now.

**Best for:** Multi-session builds — prototypes, apps, anything that takes more than one sitting. Pairs naturally with BMAD: BMAD produces the docs, GSD executes them.

### Setup

**1. Create the docs folder**

```shell
mkdir docs
```

**2. Create the four documents**

`docs/PROJECT.md` — mission, stack, design tokens, constraints. Fill in once, update rarely.

`docs/REQUIREMENTS.md` — all flows, screens, and acceptance criteria. Source of truth for what to build.

`docs/ROADMAP.md` — milestones, phases, and build sequence.

`docs/STATE.md` — what's done, in flight, and next. Update this every session.

**3. Start every session with this briefing**

```
Read docs/PROJECT.md, docs/REQUIREMENTS.md, docs/ROADMAP.md, and docs/STATE.md.

We are in Phase [A/B/C] — [phase name].
Phase [previous] is complete and verified.
We are [starting / continuing] Story [N]: [story name].
[If continuing: Stage [X] is complete. Continue from Stage [X+1].]

Confirm you understand the current state before we begin.
```

Claude reads the docs, confirms its understanding, and picks up exactly where you left off — no re-explaining the project from scratch.

### The build loop

```
Discuss → Plan → Execute → Verify → Update STATE.md → Next story
```

### Tips

- **Write REQUIREMENTS.md in design language.** Describe what the user sees and does — screen by screen. Not which components to use.
- **Keep STATE.md honest.** The quality of the next session depends entirely on how accurately it reflects where things actually are.
- **The session briefing is not optional.** Skipping it and continuing from the previous conversation is how context rot happens.
- **Figma + REQUIREMENTS.md is a strong combo.** Link to Figma frames directly in REQUIREMENTS.md and ask Claude to match them pixel-perfect.

---

## BMAD

BMAD (Breakthrough Method in Agile Development) is a multi-agent planning framework. It takes you from a rough idea to a complete set of development-ready documents by running you through a sequence of specialist AI agents — Analyst, PM, UX Expert, Architect, Product Owner, Scrum Master — each with a distinct role.

**Best for:** Starting a new project with no docs. BMAD produces the structured output (PRD, architecture, story files) that GSD or a developer executes from.

### The agents

| Agent | What they do |
|---|---|
| **bmad-orchestrator** | Coordinates workflow, switches between agents, guides you through the right process |
| **analyst** | Market research, brainstorming, competitive analysis, project briefs |
| **product manager** | Creates PRDs, manages feature prioritisation |
| **ux-expert** | UI/UX specifications, design guidelines, AI UI tool prompts |
| **architect** | System architecture, tech stack, technical implementation patterns |
| **product owner** | Validates artifacts, manages story backlogs, ensures quality before dev |
| **scrum master** | Converts epics into build-ready tickets with acceptance criteria and Definition of Done |

### Setup

**1. Get the BMAD bundle**

Download from [github.com/bmadcode/BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD). You want `bmad-agent-bundle.md`.

Also grab the ruleset and agent files from [github.com/DarrenJCoxon/aad-introduction](https://github.com/DarrenJCoxon/aad-introduction).

**2. Create your project folder**

```shell
mkdir ~/Desktop/Claude-Code/your-project
cd ~/Desktop/Claude-Code/your-project
npm init -y
```

**3. Create the folder structure**

```shell
mkdir -p docs/core docs/stories
```

**4. Launch Claude and load the bundle**

```shell
claude
```

Paste the contents of `bmad-agent-bundle.md` as your first message.

**5. Give Claude your project context + master prompt**

*Project context* (what you're building):
> I am creating a [describe project]. [User access, key features, tech constraints.]

*BMAD master prompt* (kicks off the planning session):
> I want to build [project]. We will use [stack]. Let's begin to plan!

**6. Enable skip permissions for BMAD mode**

Press `shift` + `tab` to switch Claude models. Turn on skip permissions so Claude can work autonomously through the agent sequence — only do this when you've defined everything meticulously in your docs.

### The planning sequence (Workflow #1)

```
Orchestrator activates team
    ↓
Analyst → project brief (problem, constraints, scope)
    ↓
PM → PRD (functional + non-functional requirements)
    ↓
Architect → system architecture + data model
    ↓
Product Owner → prioritised story backlog
    ↓
Designer → visual system, layout rules, design tokens
    ↓
Engineering Manager → execution sequence, risk sequencing
    ↓
Scrum Master → sprint-ready stories with acceptance criteria
    ↓
docs/core/ and docs/stories/ populated → ready for GSD
```

### Switching agents

```
*analyst           → Analyst
*pm                → PM
*ux-expert         → UX Expert
*architect         → Architect
*po                → Product Owner
*scrum-master      → Scrum Master
*bmad-orchestrator → return to Orchestrator
```

### Autonomous build prompt (after docs are ready)

Once docs and stories are in place, use this to kick off a self-driving build session in Claude:

```
You are acting as a Senior Staff Engineer and Delivery Lead.
Execute this project story by story, in strict sequence,
using the project documentation as the source of truth.
Follow all standards in CLAUDE.md — it overrides everything else.

For each story:
1. Review and cross-check against source docs
2. Implement
3. Self-review
4. Run lint, type-check, build — fix all failures
5. Set story status to Review → invoke qa-validator
6. Only move to the next story when qa-validator marks Done

The project lives at [path]. Begin with Story 1.1.
```

### Tips

- **Use the UX Expert — it's underrated.** It catches failure states, empty states, and edge cases before they're expensive to fix in code.
- **Feed in your Figma early.** Include your Figma link when briefing the PM or UX Expert.
- **Don't run every agent.** For a focused prototype: PM → UX Expert → PO is often enough.
- **BMAD output = GSD input.** UX Expert flows → `REQUIREMENTS.md`. PO stories → `ROADMAP.md`.

---

## ODD

ODD (Outcome-Driven Development) is a design-first build methodology. Instead of feature specs, you start with *personas* and *outcomes* — what a real person should be able to do when the work succeeds — and let those drive every build decision. No speculative features. No translation loss between design and engineering.

**Best for:** Projects where you're the designer *and* the builder, and you want Claude working in outcome language — not ticket language. Also used as the delivery model for SC prototypes: each epic gets one Vercel prototype as the single source of truth before engineering builds in Frontend Reactor.

### The core concepts

- **Personas** — the real people the work is for, with goals and context
- **Outcomes** — what each persona can do when the work succeeds (not features, not tasks)
- **Contracts** — the interface between outcomes so they can be built independently
- **Verification** — every outcome is walked through before it's marked done; domain language only

### Setup

**1. Install ODD Studio**

```shell
npx odd-studio init
```

**2. Open the project in Claude Code and start**

```shell
/odd
```

ODD walks you through three stages:

1. **Personas** — Who uses this? What do they care about? What's blocking them?
2. **Outcomes** — What must be true for each persona when they're done with this flow?
3. **Build** — Claude builds only what the outcomes require, verified step by step.

### Skills

| Skill | When to use |
|---|---|
| `/odd` | Start or resume an ODD project — full coach |
| `/odd-plan` | Planning phase: personas, outcomes, contracts, MIP |
| `/odd-build` | Build session: execute current phase outcome by outcome |
| `/odd-status` | Show full project state and what comes next |
| `/odd-deploy` | Verify all outcomes confirmed, deploy current phase |
| `/odd-swarm` | Build all independent outcomes in the current phase in parallel |

### The build sequence

```
Personas + Outcomes → Master Implementation Plan
                              ↓
                    Build outcome by outcome
                              ↓
               Verify in browser → commit → next outcome
```

**Commit format:** `Outcome [N] [name] — verified`

### Persona tools (SC-specific)

Two persona skills are available for SC shared device work, grounded in real discovery:

- **`/flw-dude`** — feedback through the eyes of a frontline worker on a shared tablet: ghost users, sync tax, weak signal limbo, offline user switching
- **`/admin-dude`** — feedback through the eyes of an IT admin managing 200–750+ shared devices: per-seat pricing traps, MDM limitations, compliance audits, zero-touch provisioning

Use these at the persona stage to validate you're solving the right problem for the right person.

### Tips

- **You don't need to write code.** You need to understand your users and domain. Claude handles the implementation; you handle the judgment calls.
- **Outcomes are not features.** "User can authenticate in under 10 seconds without typing" is an outcome. "Add face recognition screen" is a feature.
- **Verify before marking done.** Walk through the outcome in the browser exactly as the verification steps describe. If anything doesn't match, it's not done.

---

## Resources

| Method | Links |
|---|---|
| OpenSpec | [npmjs.com/package/@fission-ai/openspec](https://www.npmjs.com/package/@fission-ai/openspec) |
| GSD | No install needed — just Claude Code + four markdown files |
| BMAD | [github.com/bmadcode/BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) · [github.com/DarrenJCoxon/aad-introduction](https://github.com/DarrenJCoxon/aad-introduction) |
| ODD | [github.com/odd-studio/odd](https://github.com/odd-studio/odd) |
| Context7 MCP | [context7.com](https://context7.com) — keeps Claude's library knowledge current |
