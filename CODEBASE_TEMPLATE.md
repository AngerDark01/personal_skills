# CODEBASE.md — Project Ontology
<!-- Auto-maintained by codebase-ontology skill. Do not edit the structure, only the content. -->
<!-- Last updated: YYYY-MM-DD | Scanned by: codebase-ontology vX -->

---

## 1. Project Overview

**Name:** [project name]  
**Purpose:** [one paragraph — what problem this solves and for whom]  
**Tech stack:** [e.g., FastAPI + LangGraph + React + PostgreSQL + Redis]  
**Architecture pattern:** [e.g., Layered API / Event-driven / Monorepo / Microservices]

---

## 2. Module Map

> One row per top-level directory or logical module. The "Responsibility" column should be a single sentence — if you need more, the module is doing too much.

| Module/Path | Responsibility | Key files |
|---|---|---|
| `src/api/` | FastAPI route definitions and request validation | `router.py`, `schemas.py` |
| `src/agent/` | LangGraph agent graph definition and node logic | `graph.py`, `nodes/` |
| `src/db/` | Database models, migrations, query helpers | `models.py`, `crud.py` |
| ... | ... | ... |

---

## 3. Entry Points & Bootstrapping

> How the system starts. Trace from the first executed line to the point where it's "ready".

```
[Entry point file] → [what it initializes] → [what it registers/starts]
e.g., main.py → creates FastAPI app → registers routers → connects DB → starts uvicorn
```

**Key environment variables:**
| Variable | Purpose | Default |
|---|---|---|
| `DATABASE_URL` | PostgreSQL connection string | required |
| ... | ... | ... |

---

## 4. Data Flows

> The most important end-to-end flows. For each flow, show every step including the function name, file, and what happens to the data.

### Flow 1: [Name, e.g., "Fault Recommendation Request"]

**Trigger:** [e.g., POST /api/recommend]  
**Input:** [e.g., `{equipment_id: str, alarm_codes: list[str]}`]  
**Output:** [e.g., `{recommendations: list[SOP], confidence: float}`]

```
1. api/router.py:recommend_endpoint()
   → validates request via RecommendSchema
   → calls agent/graph.py:run_graph(state)

2. agent/graph.py:run_graph()
   → initializes AgentState with equipment context
   → enters LangGraph graph at node "retrieve_context"

3. agent/nodes/retriever.py:retrieve_context()
   ⚠️ GOTCHA: queries Elasticsearch with hybrid search; if ES is unavailable,
      falls back to empty context silently — no exception raised
   → returns top-K SOPs as Document objects

4. agent/nodes/reasoner.py:generate_recommendation()
   → calls LLM with retrieved context
   → parses structured output via RecommendationParser
   → ⚠️ GOTCHA: parser assumes JSON response; if LLM returns markdown,
      falls back to raw text with confidence=0.0

5. api/router.py → serializes AgentState.output → returns 200 response
```

### Flow 2: [Name]
...

---

## 5. Key Functions Index

> Only functions that are non-trivial, widely called, or likely to contain bugs. Skip boilerplate.

### `module/file.py`

#### `function_name(param1: Type, param2: Type) -> ReturnType`
**Does:** [exact description of what it actually does, not what its name implies]  
**Side effects:** [DB writes, cache invalidation, external calls, etc. "None" if clean]  
**Called by:** `caller_a.py:fn`, `caller_b.py:fn`  
**Calls:** `dep_a.py:fn`, `dep_b.py:fn`  
**⚠️ Note:** [any non-obvious behavior, edge cases, implicit assumptions]

#### `another_function(param: Type) -> ReturnType`
...

---

## 6. Call Graph — Critical Paths

> Only the edges that matter for understanding the system. Format as indented tree or adjacency list.

```
# Request handling spine
router.py:endpoint()
  └── service.py:handle()
        ├── db/crud.py:get_item()
        │     └── db/session.py:get_db()  ← context manager, auto-commits
        └── agent/graph.py:run()
              ├── nodes/retriever.py:retrieve()
              └── nodes/reasoner.py:reason()

# Background jobs
scheduler.py:run_jobs()
  └── jobs/sync.py:sync_equipment()
        └── external/api_client.py:fetch_updates()
              ⚠️ no retry logic — single timeout failure aborts full sync
```

---

## 7. External Dependencies & Integrations

| Dependency | Purpose | Where used | Notes |
|---|---|---|---|
| `elasticsearch-py` | Vector + keyword search | `retrieval/es_client.py` | Index names in `.env` |
| `langchain-core` | LLM abstraction, prompt templates | `agent/` | |
| `langgraph` | Agent state machine | `agent/graph.py` | |
| ... | | | |

**External services:**
| Service | Purpose | Failure behavior |
|---|---|---|
| Elasticsearch | SOP retrieval | Silent empty results (⚠️ see Flow 1) |
| PostgreSQL | Persistent storage | Hard crash on startup if unavailable |
| ... | | |

---

## 8. Known Risk Areas ⚠️

> Places where bugs are most likely to hide. Populated during scan and updated over time.

- **`agent/nodes/retriever.py`** — Silent fallback on ES failure means broken retrieval looks like "no relevant SOPs found" rather than an error. Easy to miss in testing.
- **`db/crud.py:bulk_insert()`** — No transaction batching; large imports can leave partial state if interrupted mid-way.
- [Add more as discovered]

---

## 9. Data Models

> Key data structures that flow through the system.

```python
# AgentState — the main state object passed through the LangGraph graph
class AgentState(TypedDict):
    equipment_id: str
    alarm_codes: list[str]
    retrieved_docs: list[Document]   # populated by retriever node
    recommendation: str | None        # populated by reasoner node
    confidence: float                 # 0.0 if parsing failed
    error: str | None                 # set on any node failure

# SOP — retrieved knowledge unit
class Document(BaseModel):
    id: str
    content: str
    source: str        # ES index + doc_id
    score: float       # retrieval relevance score
```

---

## 10. Change Log

> Append-only. Each entry added after a confirmed feature or bugfix.

### YYYY-MM-DD — Initial scan
- Full project scanned and ontology created
- X modules, Y functions, Z data flows documented
