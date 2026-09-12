# Agent Guidelines

Use [Structurizr DSL](https://docs.structurizr.com/dsl), based on Simon Brown's C4 model, to maintain this architecture repository.

## Source files

- `workspace.dsl` is the source of truth.
- `sample.dsl` is a local syntax example.
- Use the [official DSL reference](https://docs.structurizr.com/dsl/language) when syntax is unclear.

## Rules

- Keep the workspace structure: `workspace` → `model` → `views`.
- Model people, software systems, containers, components, and relationships using C4 terminology.
- Keep identifiers stable and relationship directions meaningful.
- Write concise descriptions and add technologies only when known.
- Use tags for semantic categories and styles for consistent diagrams.
- Add or update the appropriate view when the model changes.
- Do not add speculative elements or dependencies.
- After each DSL change, review `sample.dsl` and the relevant official documentation.

## Validation

There is no Structurizr CLI in this repository. After each change, manually check:

- DSL braces and workspace structure.
- Relationship endpoints and identifiers.
- View scopes and included elements.
- Syntax against `sample.dsl` and the [official DSL reference](https://docs.structurizr.com/dsl/language).

Do not claim that automated validation was performed.
