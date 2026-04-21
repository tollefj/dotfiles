---
name: elixir-macros
version: 1.0.0
description: Use when writing, debugging, or explaining Elixir macros, quote/unquote, or compile-time metaprogramming
---

# Elixir Macros

Macros operate on ASTs at compile time. They receive quoted expressions and must return quoted expressions. Use macros only when a function cannot achieve the same result.

## quote and unquote

```elixir
# quote captures the AST of an expression
quote do: 1 + 2
#=> {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}

# unquote injects a value into a quoted expression
x = 42
quote do: unquote(x) + 1
#=> {:+, [], [42, 1]}
```

## Defining a macro

```elixir
defmodule MyMacros do
  defmacro unless(condition, do: body) do
    quote do
      if !unquote(condition), do: unquote(body)
    end
  end
end

# Usage
require MyMacros
MyMacros.unless false, do: IO.puts("runs")
```

## Hygiene

Elixir macros are hygienic by default — variables bound inside a macro do not leak into the caller's scope. Use `var!` to intentionally break hygiene when needed.

```elixir
defmacro set_x(val) do
  quote do
    var!(x) = unquote(val)  # explicitly modifies caller's x
  end
end
```

## Anti-patterns to avoid

- Macros that could be functions — prefer functions.
- Macros that generate large amounts of code invisibly.
- Calling `Code.eval_string/1` — almost always wrong.

## For full reference

Call `get_module_docs` with `"macros"` for the macro guide, `"quote-and-unquote"` for quote mechanics, or `"Macro"` for the `Macro` module API.
