# Agent Guidelines

This repository maintains the **Takodu Platform** architecture using the
[C4 model](https://c4model.com/). It carries two parallel representations:

| Format             | Source files              | Tooling                                          |
| ------------------ | ------------------------- | ------------------------------------------------ |
| **Structurizr DSL**| `workspace.dsl`, `sample.dsl` | Structurizr CLI / Lite (not installed in this repo) |
| **LikeC4**         | `src/**/*.c4`             | `bunx likec4 …` only                            |

## Working rules

- **DO NOT run the project.** Do not start `likec4 serve`/`dev` or any
  long-running process. Use `bunx likec4 validate` to surface syntax / layout
  errors, or `bunx likec4 build` / `bunx likec4 gen mermaid` / `bunx likec4
  export json` to produce non-interactive artefacts.
- The Structurizr DSL files (`workspace.dsl`, `sample.dsl`) are kept for
  reference and external compatibility. They are **not** edited by the
  LikeC4 pipeline and have no automated validation in this repo.
- The LikeC4 source under `src/` is the working format.
- **Do not commit.** Leave git operations to the human operator.

## LikeC4 conventions

- **Layout:** `specification { ... }` → `model { ... }` → `views { ... }`.
- **Element kinds:** `actor`, `system`, `webapp`, `api`, `database`, `cache`,
  `component`. Custom shapes are declared in `spec.c4`.
- **Tags:** declared once in `spec.c4` (e.g. `tag external`), referenced
  inline at the **top** of an element body as `#external, #ai`. Tags must be
  the first thing inside an element block — defining them after
  `description` / `technology` is a parse error.
- **Relationships:** `from -> to 'description' { technology 'X' }`.
  Hierarchical identifiers: `takodu.haimiya.iam`, `takodu.db`, `deepseek`.
- **Views:** `view`, `view of <element>`. PascalCase directions:
  `autoLayout LeftRight` / `TopBottom`. Wildcards: `*` (top-level or scoped
  children + related), `cloud.*` (children), `cloud.**` (descendants).
- Keep identifiers stable and relationship directions meaningful
  (the existing `workspace.dsl` uses the same names).

## Validation

```bash
bunx likec4 validate         # parse + layout check
bunx likec4 gen mermaid      # non-interactive sanity check
```

Do not claim that automated Structurizr validation was performed — the
Structurizr CLI is intentionally absent from this repository.