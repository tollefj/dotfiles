---
name: elixir-debugging
version: 1.0.0
description: Use when debugging Elixir code or explaining debugging tools (IEx, dbg, observer, tracing)
---

# Debugging Elixir

## IO.inspect/2 — non-intrusive inspection

`IO.inspect/2` returns its first argument unchanged, so it can be inserted anywhere in a pipeline:

```elixir
[1, 2, 3]
|> IO.inspect(label: "before map")
|> Enum.map(&(&1 * 2))
|> IO.inspect(label: "after map")
```

## dbg/2 — pipeline debugger (Elixir 1.14+)

`dbg/2` prints the AST and value at the call site. In IEx it opens an interactive session:

```elixir
[1, 2, 3]
|> Enum.map(&(&1 * 2))
|> dbg()
```

## IEx.pry/0 — breakpoints

```elixir
require IEx
def my_function(x) do
  IEx.pry()  # execution pauses here in IEx
  x * 2
end
```

Run with `iex -S mix` for pry to work.

## :observer — visual process inspector

```elixir
:observer.start()
```

Shows the supervision tree, process list, memory usage, and ETS tables.

## :sys.get_state/1 — inspect GenServer state

```elixir
:sys.get_state(MyApp.Cache)
```

## For full reference

Call `get_module_docs` with `"debugging"` for the complete debugging guide.
