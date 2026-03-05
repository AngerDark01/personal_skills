# CODEBASE.md — Project Ontology
<!-- Auto-maintained by codebase-ontology skill. Keep structure stable; update content only. -->
<!-- Last updated: YYYY-MM-DD | Mode: SCAN/UPDATE -->

---

## 1. Project Overview

**Name:** [project name]  
**Purpose:** [what problem this solves and for whom]  
**Tech stack:** [runtime/framework/storage/integration stack]  
**Primary architecture style:** [layered/modular/event-driven/monorepo/etc.]

---

## 2. System Architecture

> System layer: global structure and constraints.

- **Runtime boundaries:** [services/processes/apps and how they connect]
- **Execution model:** [request/response, async jobs, event consumers]
- **Global constraints:** [latency, consistency, tenancy, compliance, etc.]
- **Core assumptions:** [critical invariants the system relies on]

---

## 3. Module Map

> Overview layer: one row per top-level module.

| Module/Path | Responsibility | Key files | Notes |
|---|---|---|---|
| `src/api/` | [single-sentence responsibility] | `router.py`, `schemas.py` | [important coupling/constraints] |
| ... | ... | ... | ... |

---

## 4. Entry Points & Bootstrapping

> Trace startup from first executed line to ready state.

```text
[entry file] -> [initialization] -> [registrations/connections] -> [ready]
```

**Environment variables (key only):**
| Variable | Purpose | Default | Failure behavior if missing |
|---|---|---|---|
| `DATABASE_URL` | DB connection | required | app fails at startup |
| ... | ... | ... | ... |

---

## 5. Critical Data Flows

> End-to-end flows with exact step evidence. Include at least 3 flows for SCAN.

### Flow 1: [name]

**Trigger:** [HTTP/event/cron/manual]  
**Input:** [shape]  
**Output:** [shape]

```text
1. path/file.ext:function()
   -> [what data is read/validated/transformed]
2. ...
N. path/file.ext:function()
   -> [response/write/publish effect]
```

**Failure path:** [timeouts/retries/fallback/partial writes]

### Flow 2: [name]

### Flow 3: [name]

---

## 6. Key Functions Index

> Detail layer: critical functions/classes/interfaces only.

### `module/file.py`

#### `function_name(param: Type) -> ReturnType`
**Role:** [what it actually does]  
**Input -> Output transform:** [exact structure changes]  
**Side effects:** [DB/cache/network/files/etc.]  
**Failure behavior:** [throws/swallows/retries/fallback]  
**Called by:** `a.py:fn`, `b.py:fn`  
**Calls:** `c.py:fn`, `d.py:fn`  
**Debug clues:** [logs/error codes/branch flags]  
**⚠️ Notes:** [hidden assumptions/order sensitivity]

---

## 7. Call Graph — Critical Paths

> Evidence-based edges only (no guessed links).

```text
entry.py:start()
  -> api/router.py:handle_request()
      -> service/core.py:execute()
          -> db/repo.py:save()
          -> external/client.py:call()
```

---

## 8. Data Models & Contracts

> Core models/types that flow through critical paths.

```python
class ExampleModel(TypedDict):
    id: str
    status: str
```

- Contract notes: [versioning, optional/required fields, compatibility assumptions]

---

## 9. External Integrations & Failure Behavior

| Integration | Purpose | Where used | Failure behavior | Retry/Timeout |
|---|---|---|---|---|
| PostgreSQL | persistence | `db/` | startup fails if unavailable | reconnect policy ... |
| ... | ... | ... | ... | ... |

---

## 10. Findings (P0/P1/P2)

### P0
- **[title]**
  - Evidence: `path/file.py:function` [optional line]
  - Risk: [why this can cause severe impact]
  - Trigger: [minimal repro condition]

### P1
- ...

### P2
- ...

---

## 11. Known Risk Areas

- **`path/file.py`** — [risk summary + why it is brittle]
- ...

---

## 12. Coverage Report

- Inventory source: `/tmp/codebase_files.txt` (or equivalent)
- Files reviewed deeply: [count + major directories]
- Files skimmed: [count + rationale]
- Excluded files: [generated/vendor/build artifacts]
- Uncovered critical files (if any): [path + reason]
- Iteration summary:
  - Loop 1: [what was learned]
  - Loop 2: [what was corrected]
  - Loop N: [stabilization note]

---

## 13. Change Log

### YYYY-MM-DD — [initial scan or update summary]
- Mode: `SCAN` / `UPDATE`
- Re-read scope: [paths/modules]
- Modified ontology sections: [section names]
- Added/changed/removed functions/contracts/flows: [short bullets]
- Corrected assumptions: [what changed and why]

