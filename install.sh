#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — Install a skill from AngerDark01/personal_skills
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
#     | bash -s -- <skill-name> [--project]
#
# Flags:
#   --project   Install into .claude/skills/ (current project only)
#   --global    Install into ~/.claude/skills/ (default, all projects)
#
# Examples:
#   bash -s -- codebase-ontology             # global
#   bash -s -- codebase-ontology --project   # current project only
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO="AngerDark01/personal_skills"
BRANCH="main"
SKILL_NAME=""
INSTALL_MODE="global"

# ── Parse arguments ───────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --project) INSTALL_MODE="project" ;;
    --global)  INSTALL_MODE="global"  ;;
    -*)        echo "⚠️  Unknown flag: $arg (ignoring)" ;;
    *)         SKILL_NAME="$arg" ;;
  esac
done

# ── Validate ──────────────────────────────────────────────────────────────────
if [[ -z "$SKILL_NAME" ]]; then
  echo ""
  echo "❌  No skill name provided."
  echo ""
  echo "Usage:"
  echo "  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/install.sh \\"
  echo "    | bash -s -- <skill-name> [--project]"
  echo ""
  echo "Available skills (fetching list...):"
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" \
    | tar -xz -C "$TMP" --strip-components=1 2>/dev/null
  find "$TMP/skills" -name "SKILL.md" \
    | sed "s|$TMP/skills/||" \
    | sed "s|/SKILL.md||" \
    | grep -v "^_" \
    | sort \
    | while read -r p; do
        skill_dir=$(basename "$p")
        category=$(dirname "$p")
        printf "  %-28s [%s]\n" "$skill_dir" "$category"
      done
  exit 1
fi

# ── Resolve install target ────────────────────────────────────────────────────
if [[ "$INSTALL_MODE" == "project" ]]; then
  SKILLS_DIR="$(pwd)/.claude/skills"
  SCOPE="project"
else
  SKILLS_DIR="${HOME}/.claude/skills"
  SCOPE="global"
fi

echo ""
echo "📦  Installing skill: ${SKILL_NAME}"
echo "📁  Target: ${SKILLS_DIR}/ (${SCOPE})"
echo ""

mkdir -p "$SKILLS_DIR"

# ── Download repo ─────────────────────────────────────────────────────────────
TMPDIR_WORK="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_WORK"' EXIT

echo "⬇️   Fetching repository..."
curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" \
  | tar -xz -C "$TMPDIR_WORK" --strip-components=1

# ── Find skill directory ──────────────────────────────────────────────────────
SKILL_PATH="$(find "$TMPDIR_WORK/skills" -type d -name "$SKILL_NAME" 2>/dev/null | head -1)"

if [[ -z "$SKILL_PATH" ]]; then
  echo "❌  Skill '${SKILL_NAME}' not found."
  echo ""
  echo "Available skills:"
  find "$TMPDIR_WORK/skills" -name "SKILL.md" \
    | sed "s|$TMPDIR_WORK/skills/||" \
    | sed "s|/SKILL.md||" \
    | grep -v "^_" \
    | sort \
    | while read -r p; do
        printf "  %s\n" "$(basename "$p")"
      done
  exit 1
fi

# ── Install ───────────────────────────────────────────────────────────────────
DEST="${SKILLS_DIR}/${SKILL_NAME}"

if [[ -d "$DEST" ]]; then
  echo "⚠️   '${SKILL_NAME}' already installed at ${DEST}"
  printf "    Overwrite? [y/N] "
  read -r confirm </dev/tty
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
  rm -rf "$DEST"
fi

cp -r "$SKILL_PATH" "$DEST"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✅  Done!"
echo ""
echo "Installed: ${DEST}/"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (or your agent)"
echo "  2. The skill will be auto-discovered"

case "$SKILL_NAME" in
  codebase-ontology)
    echo ""
    echo "Usage:"
    echo "  New project  → say: 'scan the project' or 'build codebase map'"
    echo "  After a fix  → say: 'update the ontology'"
    ;;
esac

echo ""
