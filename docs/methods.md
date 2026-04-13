# Methods

Structured frameworks for running longer, more ambitious sessions with Claude Code. Unlike skills (single prompts) or agents (single workflows), methods govern how an entire project is planned and built across multiple sessions.

---

## At a glance

| Method | Full name | Role | Best for |
|---|---|---|---|
| **BMAD** | BMad Method | Planning | Scoping a new project — requirements, architecture, stories |
| **GSD** | Get Shit Done | Execution | Building story by story across multiple sessions |
| **ODD** | Outcome-Driven Development | Design-first build | Projects where design quality and verified delivery matter most |

**The most common combo:** BMAD to plan → GSD to build. Use ODD when you're the designer *and* builder and want Claude working in outcome language, not ticket language.

---

## BMAD

A multi-agent planning framework. You load a bundle of specialist agents and work through them in sequence to produce a fully-scoped project: research brief, PRD, architecture, and a backlog of implementation-ready stories.

**Agents in the bundle:** Orchestrator → Analyst → PM → UX Expert → Architect → PO → Scrum Master

**What it produces:** PRD, architecture doc, story files ready for GSD or story-implementer to execute.

**Get it:** [github.com/bmadcode/BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD)

---

## GSD

A spec-driven execution framework built specifically for Claude Code. Solves *context rot* — the quality degradation that happens as Claude fills its context window across a long session — by loading four structured docs at the start of every session so Claude always knows where things stand.

**The four docs (kept in `docs/`):**

| Doc | Contains |
|---|---|
| `PROJECT.md` | Mission, stack, tokens, constraints. Rarely changes. |
| `REQUIREMENTS.md` | Scenarios, flows, acceptance criteria. |
| `ROADMAP.md` | Milestones and epics. |
| `STATE.md` | What's done, what's in flight, what's next. |

**The loop:** Discuss → Plan → Execute → Verify. Repeat per story.

**Used on:** Quick Secure Auth prototype (web + native Expo).

---

## ODD

Outcome-Driven Development. Instead of writing feature specs, you start with personas and outcomes — what a real person should be able to *do* after the work is done — and let those drive every build decision. Every outcome is verified in a browser before it's marked done.

**The ODD skills in this repo:**

| Skill | When to use |
|---|---|
| `/odd` | Start or resume an ODD project — full coach |
| `/odd-plan` | Planning phase: personas, outcomes, contracts, MIP |
| `/odd-build` | Build session: execute current phase outcome by outcome |
| `/odd-status` | Show full project state and what comes next |
| `/odd-deploy` | Verify all outcomes confirmed, deploy current phase |
| `/odd-swarm` | Build all independent outcomes in the current phase in parallel |

**The build sequence:**

```
Personas + Outcomes → Master Implementation Plan
                              ↓
                    Build outcome by outcome
                              ↓
               Verify in browser → commit → next outcome
```

**Commit format:** `Outcome [N] [name] — verified`
