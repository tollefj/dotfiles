---
name: elixir-lookup
version: 2.0.0
description: Use to look up any Elixir module, function, or concept via the elixir-mcp MCP server
---

# Elixir Documentation Lookup

Documentation is served by the `elixir-mcp` MCP server, which exposes three tools.

## When to use each tool

**You know the module name** → `mcp__elixir-mcp__get_module_docs`
```
mcp__elixir-mcp__get_module_docs({ module: "Enum" })
mcp__elixir-mcp__get_module_docs({ module: "GenServer" })
mcp__elixir-mcp__get_module_docs({ module: "pattern-matching" })
mcp__elixir-mcp__get_module_docs({ module: "ExceptionReference" })
```

**You know a concept but not which module** → `mcp__elixir-mcp__search_docs`
```
mcp__elixir-mcp__search_docs({ query: "process dictionary" })
mcp__elixir-mcp__search_docs({ query: "date time conversion" })
mcp__elixir-mcp__search_docs({ query: "binary pattern matching bitstring" })
```

**You want to browse what's available** → `mcp__elixir-mcp__list_modules`
```
mcp__elixir-mcp__list_modules({})
```
Returns all entries with their category (`guides`, `api`, `anti-patterns`, `reference`, `deprecated`) and a one-line description.

## lunr query syntax for search_docs

- `term1 term2` — either term
- `+term` — required
- `-term` — excluded
- `field:value` — search in specific field (`name:Enum`)
- `term~1` — fuzzy match with edit distance 1

## Available categories

| Category | Contents |
|---|---|
| `api` | Module API docs (Enum, String, GenServer, etc.) + ExceptionReference |
| `guides` | Conceptual guides (pattern-matching, processes, macros, etc.) |
| `anti-patterns` | Code, design, macro, process anti-pattern guides |
| `reference` | Cheat sheets, typespecs, sigils, syntax reference |
| `deprecated` | Legacy modules with migration paths |
