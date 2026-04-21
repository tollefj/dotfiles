---
name: elixir-anti-patterns
version: 1.0.0
description: Use when reviewing Elixir code for quality issues, anti-patterns, or architecture problems
---

# Elixir Anti-Patterns

## Code anti-patterns

**Unnecessary atom creation** — `String.to_atom/1` on user input can exhaust the atom table (atoms are never garbage collected). Use `String.to_existing_atom/1` instead.

**Long parameter lists** — replace with a struct or keyword options map.

**Nested `case` statements** — flatten with `with`:
```elixir
# bad
case a do
  {:ok, x} -> case b(x) do
    {:ok, y} -> y
    _ -> :error
  end
  _ -> :error
end

# good
with {:ok, x} <- a,
     {:ok, y} <- b(x),
     do: y
```

## Design anti-patterns

**God modules** — a module doing more than one thing. Split by responsibility.

**Deep coupling through process names** — using registered names across subsystem boundaries creates hidden coupling. Pass PIDs explicitly or use a Registry.

## Process anti-patterns

**Bottleneck GenServer** — a single GenServer handling all requests serialises them. Use `Registry` + worker pools or `PartitionSupervisor`.

**Linked processes without supervision** — spawned processes that crash take down the caller. Use `Task.Supervisor` or `DynamicSupervisor`.

**Sending large messages** — processes communicate by copying. Avoid sending large binaries; use ETS or references instead.

## Macro anti-patterns

**Macros instead of functions** — if it can be a function, it should be.

**`use` that does too much** — `use MyLib` should do the minimum necessary.

## For full reference

Call `get_module_docs` with `"code-anti-patterns"`, `"design-anti-patterns"`, `"process-anti-patterns"`, or `"macro-anti-patterns"`.
