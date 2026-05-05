---
name: manim-animator
description: This skill should be used when the user asks to "create an animation", "animate X", "make a manim scene", "generate a video showing", "create a manim animation that", or describes visual data or concepts to animate for a presentation. Handles translating natural language descriptions into runnable Manim Python scenes and rendering them to mp4.
version: 1.0.0
---

# Manim Animator

Translate natural language descriptions into Manim v0.20 Python scenes and render them to mp4 for use in presentation notes.

## Project Context

- **Project**: `/Users/tollef/Desktop/disputas/presentation-code`
- **Runtime**: `uv run manim` (always use uv, never bare `python` or `manim`)
- **Output**: `media/videos/<file>/<quality>/<SceneName>.mp4`
- **Render script**: `skills/manim-animator/scripts/render.sh` (in plugin dir)

## Workflow

### Step 1 — Understand the description

Before writing code, identify:
- What data or concept is being shown (numbers, flow, comparison, timeline, etc.)
- Whether it needs to be animated sequentially or all at once
- Approximate screen layout (centered, left/right split, chart + label)

Ask one clarifying question if the description is ambiguous about the data values or visual style. Do not ask multiple questions.

### Step 2 — Write the scene file

Create a new Python file in the project's `animations/` directory (create if missing). Name it descriptively: `animations/<topic>.py`.

```python
from manim import *

class <DescriptiveName>Scene(Scene):
    def construct(self):
        ...
```

Rules for the scene code:
- One scene class per file unless the user explicitly requests multiple
- No hardcoded magic numbers for layout — use `.arrange()`, `.next_to()`, `.to_edge()`
- Default background: completely black (`config.background_color = BLACK`, i.e. `#000000`). Do not use off-black/navy tints.
- Default text color: `WHITE` on the black background. Scene-accent colours may vary, but any rectangles/cards/nodes must stay on a pure-black backdrop (no gray or navy canvases).
- Keep `run_time` values short (0.5–2.0s) for presentation pacing; longer only when specifically animating a process
- End the scene with a `self.wait(1)` hold

### Step 3 — Render

Run the render script from the project directory:

```bash
cd /Users/tollef/Desktop/disputas/presentation-code
bash /Users/tollef/.claude/plugins/local/manim-animator/skills/manim-animator/scripts/render.sh animations/<file>.py <SceneName> [quality]
```

Quality options:
- `l` — 480p15, fast iteration preview (use by default for first render)
- `m` — 720p30, good for reviewing content
- `h` — 1080p60, final quality for embedding in presentations

After a successful render, report the full output path.

### Step 4 — Iterate

If the user requests changes, edit the existing scene file and re-render. Do not create a new file unless the scene is fundamentally different.

## File Organization

```
animations/
  bar_chart_revenue.py
  timeline_phases.py
  equation_derivation.py
media/
  videos/
    bar_chart_revenue/.../<Scene>.mp4
```

Do not commit `media/` to git.

## Common Animation Types

| Description type | Approach |
|-----------------|----------|
| Bar / column data | `BarChart` with `change_bar_values` |
| Line over time | `Axes` + `ax.plot()` or `ax.plot_line_graph()` |
| Comparison A vs B | Side-by-side `VGroup` with `FadeIn` |
| Step-by-step process | Sequential `FadeIn` or `Write` per bullet |
| Equation derivation | `MathTex` + `TransformMatchingTex` |
| Number counting up | `DecimalNumber` + `ChangeDecimalValue` |
| Timeline | `NumberLine` + labeled `Dot`s |
| Pie / proportion | `AnnularSector` or hand-rolled arcs |

## Additional Resources

- **`references/manim-api.md`** — Complete Mobject/animation/color/positioning reference with code examples for all common patterns
