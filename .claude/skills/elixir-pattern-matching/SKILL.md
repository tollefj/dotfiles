---
name: elixir-pattern-matching
version: 1.0.0
description: Use when writing or reviewing Elixir code involving pattern matching, guards, case/cond/with, or destructuring
---

# Elixir Pattern Matching

Pattern matching is the primary mechanism for branching and destructuring in Elixir. The `=` operator is the **match operator**, not assignment.

## Core rules

- The left side of `=` is a pattern; the right side is evaluated and must conform.
- `_` matches anything and binds nothing.
- `^var` pins a variable to its existing value instead of rebinding.
- Patterns are tried top-to-bottom in `case`, `cond`, `with`, and function heads.

## Key constructs

```elixir
# Destructuring
{:ok, value} = {:ok, 42}
%{name: name} = %{name: "Alice", age: 30}
[head | tail] = [1, 2, 3]

# Pin operator
x = 1
^x = 1   # passes
^x = 2   # MatchError

# case
case result do
  {:ok, val} -> val
  {:error, reason} -> raise reason
end

# with — chain operations, short-circuit on mismatch
with {:ok, user} <- fetch_user(id),
     {:ok, perm} <- check_permission(user) do
  {:ok, perm}
else
  {:error, _} = error -> error
end
```

## Guards

Guards restrict pattern clauses using `when`. Only a subset of Elixir expressions is allowed in guards (pure, side-effect-free).

```elixir
def classify(n) when is_integer(n) and n > 0, do: :positive
def classify(n) when is_integer(n) and n < 0, do: :negative
def classify(0), do: :zero

# Guard-safe functions: is_integer/1, is_binary/1, is_list/1,
# is_map/1, is_atom/1, is_nil/1, is_tuple/1, is_function/2,
# Kernel: +, -, *, div, rem, abs, length, map_size, elem, hd, tl
```

## For full reference

Use the `elixir-mcp` MCP server: call `mcp__elixir-mcp__get_module_docs` with `"patterns-and-guards"` for the complete advanced guide, or `mcp__elixir-mcp__search_docs` with `"guard pattern case"` to find related modules.
