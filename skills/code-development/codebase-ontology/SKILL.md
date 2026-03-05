---
name: codebase-ontology
description: "Builds and maintains a persistent CODEBASE.md ontology file that maps a project's full structure, data flows, function implementations, and call relationships. Use this skill whenever: (1) starting work on an unfamiliar codebase and needing to understand it quickly, (2) onboarding to a new project, (3) a user says \"scan the project\", \"build the codebase map\", \"initialize ontology\", or \"read the project\" — trigger a full scan; (4) after completing a feature or bugfix and a user says \"update the ontology\", \"sync the map\", \"I confirmed this feature works\" — trigger an incremental update. Always use this skill when context about the codebase structure would help avoid bugs from incomplete understanding."
---

# Codebase Ontology Skill

Maintains `CODEBASE.md` — a persistent, human- and AI-readable ontology of the project. The goal is to capture everything an engineer needs to understand the project without reading every file: architecture, data flows, key function implementations, call graphs, and known gotchas.

This solves a critical problem: AI context windows are limited, so reading source files sequentially causes missed relationships and hidden bugs. `CODEBASE.md` acts as a pre-digested global map that any agent or human can load instantly.

The skill has two modes. Read the user's intent carefully to decide which to run.

---

## Mode 1: SCAN — Build ontology from scratch

**When to use:** New project, `CODEBASE.md` doesn't exist, or user asks for a full rescan.

### Step 1: Discover project shape

Run these in parallel to form a first impression before reading any code:

```bash
# Project root structure
find . -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' \
       -not -path '*/__pycache__/*' -not -path '*/.venv/*' | sort

# Dependency files — reveals tech stack immediately
cat package.json 2>/dev/null || cat pyproject.toml 2>/dev/null || \
  cat requirements.txt 2>/dev/null || cat Cargo.toml 2>/dev/null

# Existing docs
ls README.md docs/ 2>/dev/null && cat README.md 2>/dev/null | head -80

# Config files — reveals deployment, env, external services
ls .env.example docker-compose.yml *.config.* tsconfig.json 2>/dev/null
```

### Step 2: Dispatch specialist subagents in parallel

Spawn all three simultaneously. Each agent has a focused, fresh context.

**Agent A — Architecture Explorer:**
```
Read the project's top-level directories and entry point files.
Focus on:
- What is the overall architecture? (monorepo, microservice, MVC, layered?)
- What are the main modules/packages and their single-sentence responsibility?
- What are the entry points (main.py, index.ts, app.py, server.go, etc.)?
- What framework patterns are used? (FastAPI routers, LangGraph nodes, React components, etc.)
Report as structured notes, not prose.
```

**Agent B — Data Flow Tracer:**
```
Trace how data moves through the system for the 2-3 most important operations
(e.g., a user request → response, a background job, a DB write).
Focus on:
- What triggers a flow? (HTTP request, event, schedule)
- Which functions/modules does data pass through in order?
- Where is state mutated or persisted?
- What are the critical transformation points?
- Where could data be lost, truncated, or mishandled? (flag these explicitly)
Report each flow as a numbered sequence: Step 1 → Step 2 → Step 3...
```

**Agent C — Function & Interface Analyst:**
```
Identify the most important functions, classes, and interfaces in the codebase.
For each, capture:
- Full signature (name, params, return type)
- One-sentence description of what it actually does
- Non-obvious implementation details or side effects
- What calls it / what it calls (key edges only)
Focus on: public APIs, core business logic, anything that many other things depend on.
Skip: trivial getters/setters, boilerplate, generated code.
```

### Step 3: Synthesize into CODEBASE.md

After all three agents complete, write `CODEBASE.md` using the template in `references/CODEBASE_TEMPLATE.md`.

**Rules for writing:**
- Be specific, not vague. "Handles auth" is bad. "Validates JWT in `auth/middleware.py:validate_token()`, extracts `user_id` and `roles`, raises `AuthError` on expiry" is good.
- Flag known risk areas with `⚠️` — places where bugs are likely to hide due to complexity or implicit assumptions.
- Keep function signatures exact. An AI reading this should be able to call the function correctly without opening the file.
- For data flows, show the full chain. Don't summarize away the middle steps.
- Total file should be readable in ~5 minutes but comprehensive enough to replace file-by-file reading.

Announce when done: "✅ CODEBASE.md created. X modules, Y key functions, Z data flows documented."

---

## Mode 2: UPDATE — Sync ontology after code changes

**When to use:** User confirms a feature is complete, a bugfix is verified, or explicitly asks to update the ontology.

### Step 1: Identify what changed

```bash
# What files were modified since last ontology update
git diff --name-only HEAD~1 2>/dev/null || git status --short

# See the actual changes
git diff HEAD~1 -- $(git diff --name-only HEAD~1) 2>/dev/null | head -300
```

If no git history, ask the user: "Which files did you change in this session?"

### Step 2: Targeted re-analysis

Read only the changed files and their immediate neighbors (files that import them or are imported by them).

For each changed file:
- What functions were added, modified, or removed?
- Did any data flows change? (new parameters, changed return types, new side effects)
- Did any call relationships change?
- Are there new ⚠️ risk areas?

### Step 3: Surgical update to CODEBASE.md

**Do NOT rewrite the whole file.** Make targeted edits:

1. Open `CODEBASE.md`
2. Locate the affected sections
3. Update only those sections
4. Append to the `## Change Log` section:

```
### YYYY-MM-DD — [brief description of change]
- Modified: `module/file.py` — [what changed]
- Added: `new_function(param) -> return_type` — [what it does]
- Data flow updated: [which flow and what changed]
- Removed: [anything deleted]
```

Announce: "✅ CODEBASE.md updated. Changed sections: [list]. Log entry added."

---

## Important principles

**Depth over breadth for critical paths.** It's better to deeply document the 10 most important functions than to shallowly mention 100. Ask yourself: "If a bug existed here, would reading this entry make it obvious?"

**Flag hidden complexity.** If a function has non-obvious behavior — implicit state, order-dependent side effects, silent failure modes — document it. This is the main value over reading source directly.

**Keep call graphs accurate.** Stale call graphs are worse than no call graphs. Only document edges you verified by reading the code, not inferred by name.

**The ontology is a living document.** It should lag behind code changes by at most one confirmed feature. Remind the user after significant changes: "Don't forget to run an ontology update after you confirm this feature."

---

## Reference files

- `references/CODEBASE_TEMPLATE.md` — The exact template to use when writing CODEBASE.md
