---
name: pr-monitor
description: Check CI status, read Buildkite failures, address reviewer comments, fix issues, and push until a PR is green. Pass PR number(s) as arguments.
argument-hint: <PR number(s) e.g. 30897 31056>
context: fork
---

# PR Monitor

Managing PR(s): $ARGUMENTS

Run the full check → diagnose → fix → push loop until green.

---

## Step 1: Check Status

```bash
gh pr checks $ARGUMENTS
gh pr view $ARGUMENTS --json reviews
```

- All pass + no blocking reviews → done
- Pending → wait 60s, re-check
- Failing → Step 2
- Review comments → Step 3

---

## Step 2: Read CI Failure

**Use Buildkite MCP if connected** — fetch the build, find the failing job, read its log.

**Fallback:** WebFetch the Buildkite URL from `gh pr checks` output.

Find the first failing step and the first error line.

---

## Known Failure Patterns

| Error | Fix |
|---|---|
| `ERR_PNPM_OUTDATED_LOCKFILE` | `pnpm install` → commit `pnpm-lock.yaml` |
| `ERR_PNPM_UNSUPPORTED_ENGINE` | `nvm use 22.13.0` before committing |
| `'X' is defined but never used` | Remove unused import |
| `Cannot find module 'cypress-recurse'` | `cd cypress-ui-tests && npm install --ignore-scripts` |
| Type errors | Fix the named type (never `@ts-ignore`) |
| Test failures | Fix the implementation, not the test |
| ESLint / Prettier | Fix the named violation |
| Docker / infra timeout | Escalate |

---

## Step 3: Address Reviewer Comments

Read each unresolved comment, apply code changes, reply/resolve via `gh api`.

---

## Step 4: Commit and Push

```bash
nvm use 22.13.0
gh auth switch --user the-sc-ui-rat
git add <changed files>
git commit -m "[JIRA-XXXX] <description>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
git push
```

JIRA ID comes from the branch name.

---

## Step 5: Loop

Wait 60s → re-run `gh pr checks`. Repeat until green or escalate after 3 failed attempts on the same check.
