---
name: elixir-otp
version: 1.0.0
description: Use when working with OTP supervision trees, Application, DynamicSupervisor, or process lifecycle
---

# Elixir OTP Fundamentals

OTP is the framework that makes Elixir fault-tolerant. The central pattern: processes are supervised, and supervisors restart failed children according to a configured strategy.

## Supervisor strategies

| Strategy | Behaviour |
|---|---|
| `:one_for_one` | Restart only the failed child |
| `:one_for_all` | Restart all children when any fails |
| `:rest_for_one` | Restart the failed child and those started after it |

## Basic Supervisor

```elixir
defmodule MyApp.Supervisor do
  use Supervisor

  def start_link(opts), do: Supervisor.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(_opts) do
    children = [
      MyApp.Repo,
      {MyApp.Cache, ttl: 60},
      MyApp.Worker,
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

## Application

Every Mix project is an OTP Application. Define `start/2` in your application module to boot the supervision tree:

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [MyApp.Supervisor]
    opts = [strategy: :one_for_one, name: MyApp.MainSupervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Set `mod: {MyApp.Application, []}` in `mix.exs` under `application/0`.

## DynamicSupervisor

For a variable number of worker processes (e.g. per-connection workers):

```elixir
DynamicSupervisor.start_link(name: MyApp.DynSup, strategy: :one_for_one)
DynamicSupervisor.start_child(MyApp.DynSup, {WorkerModule, args})
```

## PartitionSupervisor

When a single GenServer becomes a bottleneck (all callers serialize through one process), replace it with a `PartitionSupervisor` that manages a pool of identical workers:

```elixir
PartitionSupervisor.start_link(child_spec: WorkerModule, name: MyApp.Workers)
# Route by caller pid (consistent hashing)
GenServer.call({:via, PartitionSupervisor, {MyApp.Workers, self()}}, :request)
```

## For full API reference

Call `get_module_docs` with:
- `"supervisor-and-application"` — narrative guide covering supervision trees and Application boot
- `"Supervisor"`, `"DynamicSupervisor"`, `"PartitionSupervisor"`, `"Application"` — API reference
- `"Task.Supervisor"` — supervised async tasks
