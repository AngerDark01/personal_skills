#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — Install skills from AngerDark01/personal_skills
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/AngerDark01/personal_skills/main/scripts/install.sh \
#     | bash -s -- [options] [skill-name]
#
# Options:
#   --list                  List all available skills
#   --all                   Install all available skills
#   --category <name>       Install all skills in a category (e.g. code-development)
#   --project               Install into .claude/skills/ (current project only)
#   --global                Install into ~/.claude/skills/ (default, all projects)
#
# Examples:
#   bash -s -- codebase-ontology             # install one skill (global)
#   bash -s -- codebase-ontology --project   # install into current project
#   bash -s -- --list                        # list available skills
#   bash -s -- --all                         # install everything
#   bash -s -- --category code-development   # install by category
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO="AngerDark01/personal_skills"
BRANCH="main"
SKILL_NAME=""
INSTALL_MODE="global"
DO_LIST=false
DO_ALL=false
CATEGORY=""

# ── Parse arguments ───────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)          INSTALL_MODE="project" ;;
    --global)           INSTALL_MODE="global"  ;;
    --list)             DO_LIST=true ;;
    --all)              DO_ALL=true ;;
    --category)         shift; CATEGORY="${1:-}" ;;
    -*)                 echo "⚠️  Unknown flag: $1 (ignoring)" ;;
    *)                  SKILL_NAME="$1" ;;
  esac
  shift
done

# ── Resolve install target ────────────────────────────────────────────────────
if [[ "$INSTALL_MODE" == "project" ]]; then
  SKILLS_DIR="$(pwd)/.claude/skills"
  SCOPE="project"
else
  SKILLS_DIR="${HOME}/.claude/skills"
  SCOPE="global"
fi

# ── Download repo (shared step) ───────────────────────────────────────────────
TMPDIR_WORK="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_WORK"' EXIT

echo ""
echo "⬇️   Fetching repository..."
curl -fsSL "https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz" \
  | tar -xz -C "$TMPDIR_WORK" --strip-components=1

# ── Helper: list skills ───────────────────────────────────────────────────────
list_skills() {
  local filter_category="${1:-}"
  find "$TMPDIR_WORK/skills" -name "SKILL.md" \
    | sed "s|$TMPDIR_WORK/skills/||" \
    | sed "s|/SKILL.md||" \
    | grep -v "^_" \
    | sort \
    | while read -r p; do
        local skill_dir category
        skill_dir=$(basename "$p")
        category=$(dirname "$p")
        if [[ -z "$filter_category" || "$category" == "$filter_category" ]]; then
          printf "  %-28s [%s]\n" "$skill_dir" "$category"
        fi
      done
}

# ── Helper: install one skill ─────────────────────────────────────────────────
install_skill() {
  local name="$1"
  local dest="${SKILLS_DIR}/${name}"

  local skill_path
  skill_path="$(find "$TMPDIR_WORK/skills" -type d -name "$name" 2>/dev/null | head -1)"

  if [[ -z "$skill_path" ]]; then
    echo "❌  Skill '${name}' not found. Run --list to see available skills."
    return 1
  fi

  if [[ -d "$dest" ]]; then
    echo "⚠️   '${name}' already installed at ${dest}"
    printf "    Overwrite? [y/N] "
    read -r confirm </dev/tty
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "    Skipped."
      return 0
    fi
    rm -rf "$dest"
  fi

  cp -r "$skill_path" "$dest"
  echo "✅  Installed: ${name} → ${dest}/"
}

# ── --list ────────────────────────────────────────────────────────────────────
if [[ "$DO_LIST" == true ]]; then
  echo ""
  echo "Available skills in AngerDark01/personal_skills:"
  echo ""
  list_skills
  echo ""
  echo "Install a skill:"
  echo "  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/install.sh \\"
  echo "    | bash -s -- <skill-name>"
  echo ""
  exit 0
fi

mkdir -p "$SKILLS_DIR"

# ── --all ─────────────────────────────────────────────────────────────────────
if [[ "$DO_ALL" == true ]]; then
  echo "📦  Installing all skills → ${SKILLS_DIR}/ (${SCOPE})"
  echo ""
  while IFS= read -r p; do
    skill_name=$(basename "$p")
    install_skill "$skill_name"
  done < <(find "$TMPDIR_WORK/skills" -name "SKILL.md" \
    | sed "s|$TMPDIR_WORK/skills/||" \
    | sed "s|/SKILL.md||" \
    | grep -v "^_" \
    | sort)
  echo ""
  echo "Done. Restart Claude Code to activate skills."
  exit 0
fi

# ── --category ────────────────────────────────────────────────────────────────
if [[ -n "$CATEGORY" ]]; then
  echo "📦  Installing all skills in category '${CATEGORY}' → ${SKILLS_DIR}/ (${SCOPE})"
  echo ""
  found=0
  while IFS= read -r p; do
    skill_name=$(basename "$p")
    install_skill "$skill_name"
    found=$((found + 1))
  done < <(find "$TMPDIR_WORK/skills/${CATEGORY}" -name "SKILL.md" 2>/dev/null \
    | sed "s|$TMPDIR_WORK/skills/${CATEGORY}/||" \
    | sed "s|/SKILL.md||" \
    | grep -v "^_" \
    | sort)
  if [[ "$found" -eq 0 ]]; then
    echo "❌  No skills found in category '${CATEGORY}'."
    echo ""
    echo "Available categories:"
    find "$TMPDIR_WORK/skills" -mindepth 1 -maxdepth 1 -type d \
      | grep -v "_template" \
      | xargs -I{} basename {} \
      | sort \
      | sed 's/^/  /'
    exit 1
  fi
  echo ""
  echo "Done. Restart Claude Code to activate skills."
  exit 0
fi

# ── Single skill ──────────────────────────────────────────────────────────────
if [[ -z "$SKILL_NAME" ]]; then
  echo ""
  echo "❌  No skill name provided."
  echo ""
  echo "Usage:"
  echo "  curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/install.sh \\"
  echo "    | bash -s -- <skill-name> [--project]"
  echo ""
  echo "Available skills:"
  list_skills
  echo ""
  echo "Other options:"
  echo "  --list                  List available skills"
  echo "  --all                   Install all skills"
  echo "  --category <name>       Install all skills in a category"
  exit 1
fi

echo "📦  Installing skill: ${SKILL_NAME}"
echo "📁  Target: ${SKILLS_DIR}/ (${SCOPE})"

install_skill "$SKILL_NAME"

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
