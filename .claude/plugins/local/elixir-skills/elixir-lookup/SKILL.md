---
name: elixir-lookup
version: 1.0.0
description: Use to look up any Elixir module, function, or concept in the local documentation MCP server
---

# Elixir Documentation Lookup

The local MCP server at `http://localhost:8123/mcp` exposes three tools.

## When to use each tool

**You know the module name** → `get_module_docs`
```
get_module_docs({ module: "Enum" })
get_module_docs({ module: "GenServer" })
get_module_docs({ module: "pattern-matching" })
get_module_docs({ module: "ExceptionReference" })
```

**You know a concept but not which module** → `search_docs`
```
search_docs({ query: "process dictionary" })
search_docs({ query: "date time conversion" })
search_docs({ query: "binary pattern matching bitstring" })
```

**You want to browse what's available** → `list_modules`
```
list_modules({})
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
