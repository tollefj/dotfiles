---
name: elixir-protocols
version: 1.0.0
description: Use when implementing or extending Elixir protocols or behaviours
---

# Elixir Protocols

A protocol defines a polymorphic interface. Any data type can implement it without modifying the original type. This is how `Enum` works with any type that implements `Enumerable`.

## Defining and implementing a protocol

```elixir
defprotocol Stringify do
  @doc "Convert a value to a human-readable string"
  def to_str(value)
end

defimpl Stringify, for: Integer do
  def to_str(n), do: Integer.to_string(n)
end

defimpl Stringify, for: List do
  def to_str(list), do: Enum.map_join(list, ", ", &Stringify.to_str/1)
end
```

## Protocols vs Behaviours

| | Protocol | Behaviour |
|---|---|---|
| Targets | Any data type | Modules |
| Dispatch | Data-driven (type of first arg) | Explicit (`@behaviour MyBehaviour`) |
| Use case | Polymorphism over data | Defining a module contract |

## Core built-in protocols

| Protocol | Purpose | Corpus ID |
|---|---|---|
| `Enumerable` | Makes a type work with `Enum` and `Stream` | `"Enumerable"` |
| `Collectable` | Makes a type usable as a `Enum.into/2` target | `"Collectable"` |
| `String.Chars` | Makes a type interpolatable in `"#{value}"` | `"String.Chars"` |
| `Inspect` | Controls how `inspect/1` renders a value | `"Inspect"` |

Implementing `Enumerable` is the most common protocol task — it requires `count/1`, `member?/2`, `reduce/3`, and `slice/1`.

## For full reference

Call `mcp__elixir-mcp__get_module_docs` (from the `elixir-mcp` MCP server) with `"protocols"` for the conceptual guide, `"Protocol"` for the module API, or `"Enumerable"` / `"Collectable"` for the core protocols.
