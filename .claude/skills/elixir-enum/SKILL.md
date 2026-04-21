---
name: elixir-enum
version: 1.0.0
description: Use when working with Elixir Enum, Stream, or collection transformations
---

# Elixir Enum & Stream

Fetch full API documentation via the `elixir-mcp` MCP server:

```
mcp__elixir-mcp__get_module_docs({ module: "Enum" })       # Full Enum API (3000+ lines)
mcp__elixir-mcp__get_module_docs({ module: "enum-cheat" }) # Quick cheatsheet with examples
mcp__elixir-mcp__get_module_docs({ module: "Stream" })     # Lazy counterpart to Enum
mcp__elixir-mcp__get_module_docs({ module: "MapSet" })     # Set operations
mcp__elixir-mcp__get_module_docs({ module: "Keyword" })    # Keyword list operations
```

## Quick orientation

| Need | Function |
|---|---|
| Transform each element | `Enum.map/2` |
| Keep elements matching predicate | `Enum.filter/2` |
| Accumulate to a single value | `Enum.reduce/3` |
| Group elements | `Enum.group_by/2` |
| Sort | `Enum.sort/1`, `Enum.sort_by/2` |
| Find first match | `Enum.find/2` |
| Check any/all match | `Enum.any?/2`, `Enum.all?/2` |
| Lazy pipeline | `Stream.map/2`, `Stream.filter/2`, then `Enum.to_list/1` |

Use `Stream` (lazy) when: the source is infinite, you are chaining many transformations, or the collection is large and you only need the first N results.

## For search
```
mcp__elixir-mcp__search_docs({ query: "chunk flat_map zip group" })
```
