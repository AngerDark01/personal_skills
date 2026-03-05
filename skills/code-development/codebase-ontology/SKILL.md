---
name: codebase-ontology
description: "Build and maintain a full-detail CODEBASE.md ontology via iterative read-understand-revise loops with strict coverage gates. Use for project mapping/本体构建, onboarding, architecture analysis, root-cause debugging, and any task requiring overview + implementation-level evidence from source code."
---

# Codebase Ontology (Iterative, Full-Detail)

Maintains `CODEBASE.md` as a living ontology for both AI and humans.
Goal: produce a document that supports fast architecture understanding and real debugging, not shallow summaries.

Core requirements:
- Iterate on real source code (`Read -> Understand -> Revise -> Cross-check`)
- Preserve `System + Overview + Detail` layers
- Record evidence with precise file/function references
- Keep ontology synchronized after confirmed code changes

---

## Mode Selection

- `SCAN`: build from scratch (new project, missing ontology, or full rescan requested).
- `UPDATE`: incrementally update existing ontology after verified changes.

---

## 1) Coverage First (must do)

Do not rely on README/directory summaries alone.
Create a source inventory first, then deep-read by runtime importance.

Suggested commands:

```bash
# Full file inventory (adjust excludes per project)
rg --files -g '!node_modules' -g '!.git' -g '!dist' -g '!build' -g '!coverage' > /tmp/codebase_files.txt

# Dependency/config/entry hints
ls -1 package.json pyproject.toml requirements.txt Cargo.toml go.mod pom.xml 2>/dev/null
rg -n "main\\(|if __name__ == '__main__'|createApp|FastAPI\\(|express\\(|router\\.|Django|Flask|uvicorn|spring" .
```

Reading priority:
1. Entry/bootstrap layer (server/app/CLI/frontend entry).
2. Core execution paths (request handling, background jobs, persistence).
3. Data contracts (models/schema/types/DTO).
4. Integration boundaries (DB/cache/queue/third-party APIs/filesystem/LLM).
5. Supporting utilities that alter runtime behavior.

For `SCAN`, cover all business-source files except generated/vendor/build artifacts.

---

## 2) Iterative Deep-Read Loop (must do)

Run repeated loops per subsystem:
1. `Read`: target subsystem + direct caller/callee boundaries.
2. `Understand`: derive real control flow, data transitions, side effects, failure paths.
3. `Revise`: immediately update ontology sections.
4. `Cross-check`: validate assumptions against adjacent modules.

Exit loop when all are true:
- Two consecutive loops produce only minor wording clarifications.
- Critical path call edges are closed (no obvious missing links).
- No uncovered critical business files remain in inventory.

---

## 3) Ontology Structure (System + Overview + Detail)

Always keep three aligned layers:

1. **System layer**
   - Purpose, architecture style, runtime boundaries, global constraints.
2. **Overview layer**
   - Module map, entry/boot process, critical end-to-end flows, major integrations.
3. **Detail layer**
   - Function/class signatures, input/output transforms, call edges, side effects, failure behavior, hidden assumptions.

Consistency rules:
- If detail changes, update overview/system conclusions.
- If overview assumptions change, revisit affected detail sections.

---

## 4) Detail Capture Standard (debug-oriented)

For each critical function/class/interface capture:
- Exact signature (name, params, return type/shape)
- Actual behavior (not inferred from naming)
- Input/output and structure transformations
- Side effects (DB/cache/network/files/process/thread)
- Failure behavior (exception, fallback, retry policy, timeout, partial write/rollback)
- Key call edges (called by / calls)
- Debug clues (error paths, branch guards, flags, logging points)

Skip trivial boilerplate/getters/setters/generated code unless they affect behavior.

For each critical data flow, provide step-by-step chain with `file:function` evidence.

---

## 5) Findings and Risk Model (required)

Always include Findings with severity:
- `P0`: data loss/corruption, security exposure, concurrency/transaction correctness risk
- `P1`: user-visible wrong behavior, broken contracts/interfaces
- `P2`: maintainability hazards likely to cause regressions

Each finding must include:
- what is wrong
- why it is risky
- exact evidence (`file:function`, optional line refs)
- short trigger/reproduction hint when possible

---

## 6) Output Contract

Write to user target path. If target is a directory, write `CODEBASE.md` inside it.

Required sections:
1. `Project Overview`
2. `System Architecture`
3. `Module Map`
4. `Entry Points & Bootstrapping`
5. `Critical Data Flows`
6. `Key Functions Index`
7. `Call Graph — Critical Paths`
8. `Data Models & Contracts`
9. `External Integrations & Failure Behavior`
10. `Findings (P0/P1/P2)`
11. `Known Risk Areas`
12. `Coverage Report`
13. `Change Log`

`SCAN` quality baseline:
- At least 3 concrete end-to-end flows
- File-level evidence in Findings
- At least one substantive correction across iterative loops

---

## 7) UPDATE Mode Rules

1. Identify changed files (`git diff`/`git status`).
2. Re-read changed files plus one-hop neighbors (imports/importers/callers/callees).
3. If changes affect entry points/contracts/core flows, escalate to partial rescan.
4. Apply surgical edits to affected ontology sections.
5. Append dated `Change Log` entry including re-read scope and corrected assumptions.

Do not preserve stale statements proven false by re-read evidence.

---

## 8) Practical Rules

- Prefer fast scan (`rg`) then targeted deep reads.
- Mark non-verified statements explicitly as `inferred`.
- Keep call graphs evidence-based; do not invent edges by naming intuition.
- Prioritize usefulness for troubleshooting over concise prose.

---

## Reference Files

- `references/CODEBASE_TEMPLATE.md` — canonical template for writing/updating `CODEBASE.md`

