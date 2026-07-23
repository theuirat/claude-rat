#!/usr/bin/env bash
# local-ci — run a repo's CI gates on THIS machine, project-adaptively.
#
# Portable stand-in for a GitHub Actions pipeline: reproduces the same gate
# commands CI runs, natively (no Docker), so a push is verifiable without
# spending Actions minutes — or when the Actions minute-pool is exhausted and
# GitHub can't start a runner (jobs fail in ~2s with runner_id:0 and no logs,
# which is the billing meter, not the code).
#
# Design (grounded in current best practice):
#   • Auto-detect the package manager from the lockfile — never hardcode.
#   • Run the project's OWN scripts (typecheck/lint/test/build) — that's what
#     CI runs; resolving through package.json = max parity.
#   • Frozen-lockfile install for trustworthy evidence (opt-in --clean).
#   • Secret scan as a graceful-degradation ladder: gitleaks → trufflehog →
#     secretlint → a built-in offline sweep that WARNS rather than silently
#     passing.
#   • Lighthouse only if the repo has an lhci config; prod build; auto-detect
#     Chrome, else skip-with-warning (never hard-fail for a missing browser).
#   • Run-all-and-report by default (full punch-list); --bail for fail-fast.
#   • Honest: a local green is EVIDENCE, not a merge gate. Branch protection
#     still reads GitHub's own results.
#
# Written for portability incl. macOS's bash 3.2 (no associative arrays,
# no mapfile, no ${var,,}).
#
# Usage:
#   local-ci.sh                 # detect + run every gate, report a summary
#   local-ci.sh --quick         # typecheck + lint + secretscan only (fast)
#   local-ci.sh --with-lighthouse
#   local-ci.sh --clean         # fresh frozen install first (mirrors CI closest)
#   local-ci.sh --bail          # stop at the first failing gate
#   local-ci.sh --install       # skip gates, just run the frozen install
#
# Optional per-repo config, sourced if present (gitignored): a repo that needs
# build-time env (e.g. placeholder provider keys so a Next.js route's SDK
# constructors don't throw at "Collecting page data") puts them in
#   .claude/local-ci.env
# at the repo root. See the local-ci skill for the ply-chatbot example.

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "local-ci: not in a git repo"; exit 2; }
cd "$ROOT" || exit 2

QUICK=0; WITH_LH=0; CLEAN=0; BAIL=0; INSTALL_ONLY=0
for a in "$@"; do
  case "$a" in
    --quick) QUICK=1 ;;
    --with-lighthouse) WITH_LH=1 ;;
    --clean) CLEAN=1 ;;
    --bail) BAIL=1 ;;
    --install) INSTALL_ONLY=1 ;;
    -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
    *) echo "local-ci: unknown arg '$a'"; exit 2 ;;
  esac
done

say() { printf '%s\n' "$*"; }
rule() { say "──────────────────────────────────────────────────────────"; }

# ── Per-repo env (build secrets etc.) ──────────────────────────────────────
if [ -f .claude/local-ci.env ]; then
  say "local-ci: sourcing .claude/local-ci.env"
  set -a; . ./.claude/local-ci.env; set +a
fi

# ── Detect package manager from the lockfile (Corepack field wins) ─────────
PM=""; PM_INSTALL=""; PM_FROZEN=""; PM_RUN=""
detect_pm() {
  local pmfield
  pmfield="$(node -e 'try{process.stdout.write((require("./package.json").packageManager||"").split("@")[0])}catch(e){}' 2>/dev/null)"
  if [ -n "$pmfield" ]; then PM="$pmfield"
  elif [ -f pnpm-lock.yaml ]; then PM="pnpm"
  elif [ -f yarn.lock ]; then PM="yarn"
  elif [ -f bun.lockb ] || [ -f bun.lock ]; then PM="bun"
  elif [ -f package-lock.json ] || [ -f npm-shrinkwrap.json ]; then PM="npm"
  fi
  case "$PM" in
    pnpm) PM_FROZEN="pnpm install --frozen-lockfile"; PM_RUN="pnpm" ;;
    yarn) PM_FROZEN="yarn install --immutable";        PM_RUN="yarn" ;;
    bun)  PM_FROZEN="bun install --frozen-lockfile";   PM_RUN="bun run" ;;
    npm)  PM_FROZEN="npm ci";                          PM_RUN="npm run" ;;
    *)    PM="";                                        PM_RUN="" ;;
  esac
}

# Does package.json define a script named $1?
has_script() {
  [ -f package.json ] || return 1
  node -e 'const s=(require("./package.json").scripts)||{};process.exit(s[process.argv[1]]?0:1)' "$1" 2>/dev/null
}

detect_pm

SUMMARY=""; FAIL=0
# record <label> <state> — appends one aligned summary row (portable, no arrays).
record() { SUMMARY="$SUMMARY$(printf '  %-14s %s' "$1" "$2")
"; }

run_gate() {
  # run_gate <label> <cmd...>
  local label="$1"; shift
  say ""; rule; say "▶ $label"; rule
  if "$@"; then record "$label" "PASS"
  else
    record "$label" "FAIL"; FAIL=1
    [ "$BAIL" -eq 1 ] && { summary; exit 1; }
  fi
}

# A gate that maps to a package.json script; skipped (not failed) if absent.
script_gate() {
  # script_gate <label> <script-name>
  local label="$1" script="$2"
  if [ -z "$PM_RUN" ]; then record "$label" "SKIP(no pm)"; return; fi
  if has_script "$script"; then run_gate "$label" $PM_RUN "$script"
  else record "$label" "SKIP(no script)"; fi
}

# ── Secret scan: gitleaks → trufflehog → secretlint → builtin sweep ────────
secret_scan() {
  if command -v gitleaks >/dev/null 2>&1; then
    say "gitleaks $(gitleaks version 2>/dev/null) — scanning working tree"
    gitleaks dir . --no-banner --redact; return $?
  fi
  if command -v trufflehog >/dev/null 2>&1; then
    say "trufflehog — scanning filesystem (offline, --no-verification)"
    trufflehog filesystem . --no-verification --fail 2>/dev/null; return $?
  fi
  if [ -f package.json ] && node -e 'const p=require("./package.json");const d=Object.assign({},p.dependencies,p.devDependencies);process.exit(d["secretlint"]?0:1)' 2>/dev/null; then
    say "secretlint (project devDependency) — scanning tracked files"
    $PM_RUN secretlint "**/*" 2>/dev/null; return $?
  fi
  say "No gitleaks/trufflehog/secretlint found — built-in offline sweep (stopgap)."
  say "Canonical scan is gitleaks (brew install gitleaks); this is a safety net."
  say ""
  builtin_secret_sweep
}

builtin_secret_sweep() {
  # High-signal shapes only, to keep false positives low. Scans TRACKED files
  # (what a push would carry). Excludes CI workflows + this tool (they name the
  # shapes on purpose).
  local pats hits line pat
  pats='-----BEGIN [A-Z ]*PRIVATE KEY-----
AKIA[0-9A-Z]{16}
sk-ant-[A-Za-z0-9_-]{24,}
sk-[A-Za-z0-9]{32,}
gsk_[A-Za-z0-9]{24,}
ghp_[A-Za-z0-9]{36}
github_pat_[A-Za-z0-9_]{60,}
xox[baprs]-[0-9A-Za-z-]{10,}
AIza[0-9A-Za-z_-]{35}'
  hits=0
  while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      case "$line" in
        *".github/workflows/"*|*"local-ci.sh"*) continue ;;
      esac
      say "  ⚠ $line"; hits=$((hits+1))
    done <<EOF
$(git grep -nIE "$pat" -- . ':!*.github/workflows/*' ':!*local-ci.sh' 2>/dev/null)
EOF
  done <<EOF
$pats
EOF
  if [ "$hits" -gt 0 ]; then
    say ""; say "$hits potential secret(s) in tracked files — review before pushing."
    return 1
  fi
  say "No high-signal secrets found in tracked files."
  return 0
}

# ── Lighthouse (only if the repo has an lhci config) ───────────────────────
has_lhci_config() { ls lighthouserc.* >/dev/null 2>&1; }
lighthouse_gate() {
  if ! has_lhci_config; then record "lighthouse" "SKIP(no config)"; return; fi
  if [ -z "${CHROME_PATH:-}" ]; then
    local c
    for c in \
      "$(command -v google-chrome 2>/dev/null)" \
      "$(command -v chromium 2>/dev/null)" \
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
      $(ls -d /opt/pw-browsers/chromium-*/chrome-linux/chrome 2>/dev/null | head -1) \
      "$(ls -d "$HOME"/.cache/ms-playwright/chromium-*/chrome-linux/chrome 2>/dev/null | head -1)"; do
      if [ -n "$c" ] && [ -x "$c" ]; then export CHROME_PATH="$c"; break; fi
    done
  fi
  if [ -z "${CHROME_PATH:-}" ]; then
    say "No Chrome/Chromium found — skipping lighthouse (set CHROME_PATH to run it)."
    record "lighthouse" "SKIP(no chrome)"; return
  fi
  say "▶ lighthouse (informational — reports scores, never blocks the push)"
  say "CHROME_PATH=$CHROME_PATH"
  if $PM_RUN exec lhci autorun 2>/dev/null || npx --no-install lhci autorun; then
    record "lighthouse" "PASS"
  else
    record "lighthouse" "WARN"   # warn-only, matches lhci assert level
  fi
}

summary() {
  say ""; say "═══════════════════ local-ci summary ═══════════════════"
  say "  repo: $(basename "$ROOT")   package-manager: ${PM:-none}"
  printf '%s' "$SUMMARY"
  say "════════════════════════════════════════════════════════"
  if [ "$FAIL" -eq 0 ]; then
    say "✔ all hard gates green — safe to push (this is evidence, not the merge gate)."
  else
    say "✗ one or more gates FAILED — fix before pushing."
  fi
}

# ── Run ────────────────────────────────────────────────────────────────────
if [ -z "$PM" ]; then
  say "local-ci: no recognizable lockfile (pnpm/yarn/bun/npm) — nothing to run."
  exit 2
fi
say "local-ci: package manager = $PM"

if [ "$CLEAN" -eq 1 ] || [ "$INSTALL_ONLY" -eq 1 ]; then
  run_gate "install" sh -c "$PM_FROZEN"
  [ "$INSTALL_ONLY" -eq 1 ] && { summary; exit "$FAIL"; }
fi

script_gate "typecheck" "typecheck"
script_gate "lint"      "lint"
if [ "$QUICK" -eq 0 ]; then
  script_gate "test"  "test"
  script_gate "build" "build"
fi
run_gate "secretscan" secret_scan
if [ "$WITH_LH" -eq 1 ] && [ "$QUICK" -eq 0 ]; then
  lighthouse_gate
fi

summary
exit "$FAIL"
