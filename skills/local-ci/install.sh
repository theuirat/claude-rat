#!/usr/bin/env bash
# install.sh — wire the Actions-aware local-ci pre-push hook into git.
#
# The skill (SKILL.md) and agent (ci-local-runner) are picked up automatically
# by however you already sync this repo into ~/.claude. This installer only
# handles the genuinely new machinery: the git hook that runs the local gate
# when GitHub Actions is maxed out.
#
# Two ways to install, because git hooks aren't global by default:
#
#   ./install.sh --global
#       Installs a GLOBAL hook: copies the hook + runner to ~/.claude/git-hooks
#       and points `git config --global core.hooksPath` at it. Applies to every
#       repo that does NOT set its own core.hooksPath.
#       ⚠ Repos using husky/lefthook set a repo-local core.hooksPath, which
#         OVERRIDES the global one — for those, use --repo inside the repo.
#
#   ./install.sh --repo          (run from inside a repo)
#       Wires this repo only. If it uses husky (.husky/pre-push), appends a call
#       to the Actions-aware hook AFTER husky's own fast checks. Otherwise
#       installs into .git/hooks/pre-push.
#
#   ./install.sh --uninstall-global   # unset the global core.hooksPath
#
# Idempotent: re-running is safe.

set -euo pipefail

SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOOKS="$HOME/.claude/git-hooks"
MARK="# >>> local-ci actions-aware hook >>>"
MARK_END="# <<< local-ci actions-aware hook <<<"

info() { printf '  %s\n' "$*"; }

install_global() {
  mkdir -p "$CLAUDE_HOOKS"
  cp "$SELF_DIR/pre-push" "$CLAUDE_HOOKS/pre-push"
  cp "$SELF_DIR/local-ci.sh" "$CLAUDE_HOOKS/local-ci.sh"
  chmod +x "$CLAUDE_HOOKS/pre-push" "$CLAUDE_HOOKS/local-ci.sh"
  git config --global core.hooksPath "$CLAUDE_HOOKS"
  echo "Installed GLOBAL hook:"
  info "hooks path : $CLAUDE_HOOKS"
  info "core.hooksPath (global) -> $(git config --global core.hooksPath)"
  info "Repos with their own hook manager (husky/lefthook) override this —"
  info "run './install.sh --repo' inside those."
}

uninstall_global() {
  if [ "$(git config --global core.hooksPath 2>/dev/null || true)" = "$CLAUDE_HOOKS" ]; then
    git config --global --unset core.hooksPath
    echo "Removed global core.hooksPath."
  else
    echo "Global core.hooksPath is not ours; leaving it alone."
  fi
}

install_repo() {
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not inside a git repo."; exit 1; }
  local runner_target="$CLAUDE_HOOKS/local-ci.sh"
  # Ensure the runner exists where the hook will look for it.
  mkdir -p "$CLAUDE_HOOKS"
  cp "$SELF_DIR/local-ci.sh" "$runner_target"; chmod +x "$runner_target"

  if [ -f .husky/pre-push ]; then
    if grep -qF "$MARK" .husky/pre-push; then
      echo "Already wired into .husky/pre-push."; return
    fi
    {
      echo ""
      echo "$MARK"
      echo "# Runs the local CI gate only when GitHub Actions is maxed out."
      echo "\"\$HOME/.claude/git-hooks/pre-push\" || exit 1"
      echo "$MARK_END"
    } >> .husky/pre-push
    echo "Appended Actions-aware call to .husky/pre-push (after husky's own checks)."
  else
    local dir; dir="$(git rev-parse --git-path hooks)"
    mkdir -p "$dir"
    cp "$SELF_DIR/pre-push" "$dir/pre-push"; chmod +x "$dir/pre-push"
    echo "Installed .git/hooks/pre-push in this repo."
  fi
}

case "${1:-}" in
  --global)          install_global ;;
  --uninstall-global) uninstall_global ;;
  --repo)            install_repo ;;
  *)
    sed -n '2,34p' "$0"
    exit 0
    ;;
esac
