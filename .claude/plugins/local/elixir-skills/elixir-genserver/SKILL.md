---
name: elixir-genserver
version: 1.0.0
description: Use when implementing, debugging, or explaining a GenServer, Agent, or stateful process in Elixir
---

# Elixir GenServer

A `GenServer` is an OTP behaviour for a stateful server process. It handles synchronous calls (`handle_call/3`) and asynchronous casts (`handle_cast/2`), plus arbitrary messages (`handle_info/2`).

## Minimal GenServer

```elixir
defmodule Counter do
  use GenServer

  # Client API
  def start_link(initial \\ 0), do: GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  def increment, do: GenServer.cast(__MODULE__, :increment)
  def value, do: GenServer.call(__MODULE__, :value)

  # Server callbacks
  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_cast(:increment, state), do: {:noreply, state + 1}

  @impl true
  def handle_call(:value, _from, state), do: {:reply, state, state}
end
```

## Return tuples

| Callback | OK return | Stop return |
|---|---|---|
| `init/1` | `{:ok, state}` | `{:stop, reason}` |
| `handle_call/3` | `{:reply, reply, state}` | `{:stop, reason, reply, state}` |
| `handle_cast/2` | `{:noreply, state}` | `{:stop, reason, state}` |
| `handle_info/2` | `{:noreply, state}` | `{:stop, reason, state}` |

## Common mistakes

- Doing slow work inside `handle_call` blocks the caller — use `handle_cast` + notifications or spawn a `Task`.
- Not implementing `handle_info/2` means unexpected messages generate a Logger warning but do not crash the process. Add a catch-all clause to surface unexpected messages deliberately.
- Forgetting `@impl true` means typos in callback names compile silently.

## For full API reference

Call `get_module_docs` with `"GenServer"` for the complete callback reference including `terminate/2`, `code_change/3`, and `format_status/1`.
