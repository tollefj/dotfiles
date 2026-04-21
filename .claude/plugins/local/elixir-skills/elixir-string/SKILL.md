---
name: elixir-string
version: 1.0.0
description: Use when working with Elixir String, Regex, URI, or binary operations
---

# Elixir String, Regex & Binaries

Fetch full API documentation via MCP tools:

```
get_module_docs({ module: "String" })  # Full String API
get_module_docs({ module: "Regex" })   # Regular expressions
get_module_docs({ module: "URI" })     # URI parsing and encoding
get_module_docs({ module: "Base" })    # Base16/32/64 encoding
```

## Quick orientation

| Need | Function |
|---|---|
| Split on delimiter | `String.split/2` |
| Join list | `Enum.join/2` |
| Match pattern | `String.match?/2` |
| Replace | `String.replace/3` |
| Trim whitespace | `String.trim/1` |
| Convert to atoms safely | `String.to_existing_atom/1` |
| Regex match | `Regex.match?(~r/pattern/, str)` |
| Capture groups | `Regex.named_captures/2` |
| Parse URI | `URI.parse/1` |

## Binaries and charlists

Elixir strings are UTF-8 binaries. A charlist is a list of codepoints — used in Erlang interop.

```elixir
"hello" == <<104, 101, 108, 108, 111>>  # true (same binary)
'hello' == [104, 101, 108, 108, 111]    # true (charlist)
```

Convert: `String.to_charlist/1`, `List.to_string/1`.

## For search

```
search_docs({ query: "binary pattern match bitstring" })
search_docs({ query: "unicode grapheme codepoint" })
```
