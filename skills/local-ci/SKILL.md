---
name: local-ci
description: Run a repo's GitHub Actions CI gates on this machine — typecheck, lint, test, build, secret scan, and (if configured) lighthouse — so a push is verifiable without spending GitHub Actions minutes, or when the Actions minute-pool is maxed out and GitHub can't start a runner (jobs fail in ~2s with runner_id:0 and no logs). Project-adaptive: auto-detects the package manager and runs the project's own gate scripts, so it works in any repo, not just one. Also ships an Actions-aware pre-push hook that engages the local gate ONLY when GitHub Actions is exhausted. Use before opening a PR, when CI shows no-runner failures, or any time someone says "run CI locally", "check before I push", "run the gates", or "GitHub's checks are red but there are no logs".
argument-hint: "[--quick | --with-lighthouse | --clean | --bail]"
context: fork
---

# local-ci — run CI on your machine, only when GitHub can't

Args: $ARGUMENTS

GitHub Actions is metered — a fixed pool of runner-minutes per month. When it's exhausted, GitHub can't start a runner, so checks fail in ~2 seconds with `runner_id: 0` and **no logs**. That's the billing meter, not the code. This skill reproduces those exact gates locally so work stays verifiable, and wires a hook that runs them automatically **only when Actions is maxed out** — so on normal days GitHub does CI and pushes stay fast.

## Run it

From anywhere inside a repo:

```bash
~/.claude/skills/local-ci/local-ci.sh              # every gate + summary
~/.claude/skills/local-ci/local-ci.sh --quick      # typecheck + lint + secret scan (fast)
~/.claude/skills/local-ci/local-ci.sh --with-lighthouse
~/.claude/skills/local-ci/local-ci.sh --clean      # frozen install first (closest to CI)
~/.claude/skills/local-ci/local-ci.sh --bail       # stop at first failure
```

It prints a per-gate summary and exits non-zero iff a **hard** gate fails (lighthouse is warn-only, never blocks).

### What it runs, and how it adapts

It does **not** hardcode commands — it introspects the repo (best practice for a cross-project tool):

1. **Package manager** from the lockfile (Corepack `packageManager` field wins): `pnpm-lock.yaml`→`pnpm … --frozen-lockfile`, `yarn.lock`→`yarn … --immutable`, `bun.lock(b)`→`bun … --frozen-lockfile`, `package-lock.json`→`npm ci`.
2. **Gates** = the project's own `package.json` scripts — `typecheck`, `lint`, `test`, `build`. Running the scripts CI runs is what gives maximum parity. A script that doesn't exist is reported `SKIP`, not failed.
3. **Secret scan** as a graceful-degradation ladder: `gitleaks` → `trufflehog --no-verification` → project `secretlint` → a built-in offline pattern sweep that **warns** rather than silently passing (private keys, AWS/Anthropic/OpenAI/Groq keys, GitHub PATs, Slack/Google tokens).
4. **Lighthouse** only if the repo has an `lighthouserc.*`; runs against the prod build, auto-detects Chrome (system → Playwright's Chromium), and **skips with a warning** if no browser exists rather than hard-failing.

### Repos that need build-time env

Some builds instantiate SDKs at module load and throw without env (e.g. a Next.js route whose provider SDK constructors need a key at "Collecting page data"). Put dummy values in a gitignored **`.claude/local-ci.env`** at the repo root; the runner sources it automatically. Example for ply-chatbot:

```bash
# .claude/local-ci.env  (gitignored — placeholder values only)
SKIP_ENV_VALIDATION=true
ANTHROPIC_NO_TRAIN_VERIFIED=true
GROQ_NO_TRAIN_VERIFIED=true
OPENAI_NO_TRAIN_VERIFIED=true
ANTHROPIC_API_KEY=sk-ant-build-placeholder
GROQ_API_KEY=gsk_build_placeholder
OPENAI_API_KEY=sk-build-placeholder
DATABASE_URL=postgresql://build:placeholder@localhost:5432/build
NEXT_PUBLIC_SUPABASE_URL=https://build-placeholder.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=build-placeholder
```

## Automate it — the Actions-aware pre-push hook

The hook runs the gate on `git push` **only when GitHub Actions is maxed out**:

| GitHub Actions status | Hook does |
| --- | --- |
| Healthy (minutes remaining) | Skips — GitHub will run CI. Push stays fast. |
| Maxed (minutes exhausted) | Runs the full local gate; blocks the push on failure. |
| Unknown (no `gh`/token) | Skips with a note (honors "only when maxed"); force with `LOCAL_CI_FORCE=1`. |

It checks status via the GitHub CLI (`gh api /users/<owner>/settings/billing/actions`), cached 10 minutes so it doesn't add a network call to every push.

Install (run on your machine):

```bash
# Global — every repo without its own hook manager:
~/.claude/skills/local-ci/install.sh --global

# Per-repo — for husky/lefthook repos (e.g. ply-chatbot); appends AFTER their
# own fast checks so both run:
cd <repo> && ~/.claude/skills/local-ci/install.sh --repo
```

Escape hatches: `LOCAL_CI_SKIP=1 git push` (never), `LOCAL_CI_FORCE=1 git push` (always), `LOCAL_CI_ACTIONS=healthy|maxed git push` (override auto-detect — set `healthy` permanently if you carry a **paid** Actions budget, since overage means GitHub still runs).

## The honest limits (say these out loud)

A local green is **evidence that cuts failed CI runs**, not a replacement for CI:

- It runs on *your* machine, so it can't catch every "works on my machine" bug a clean independent runner would.
- It does **not** turn a PR's GitHub checks green — branch protection reads GitHub's own results; only GitHub can satisfy a required check.
- It leaves no shared, auditable server-side record.

So: use it to stay unblocked and verify while Actions is capped. When the pool resets (first of the month) or you raise the Actions budget in **Settings → Billing → Actions**, real CI runs again and restores the badges + merge gate. Heavier live gates (e.g. contract/eval suites that make real API calls) are intentionally out of scope — they belong in CI/pre-deploy, not on every push.

## Pairs with

- **`ci-local-runner`** agent — runs this and reports green/red in plain English.
- Your existing `pr-monitor` — watches the *real* GitHub CI once minutes are back.
