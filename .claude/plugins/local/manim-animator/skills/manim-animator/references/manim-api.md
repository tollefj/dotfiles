# Manim v0.20 API Reference

## Scene Skeleton

```python
from manim import *

class MyScene(Scene):
    def construct(self):
        # Create mobjects, add them, animate them
        title = Text("Hello", font_size=48)
        self.play(Write(title))
        self.wait(1)
        self.play(FadeOut(title))
```

## Mobjects (visual objects)

### Text & Math
| Class | Use |
|-------|-----|
| `Text("string", font_size=36)` | Plain text |
| `MathTex(r"\frac{a}{b}")` | LaTeX math, rendered via MathJax |
| `Tex(r"Some \LaTeX")` | Full LaTeX (prose + math) |
| `MarkupText("<b>bold</b>")` | Pango markup for rich text |
| `Title("Section")` | Large centered title (shortcut) |
| `Paragraph("line1", "line2")` | Multi-line text block |

### Shapes
| Class | Notes |
|-------|-------|
| `Circle(radius=1, color=BLUE)` | Circle |
| `Square(side_length=2)` | Square |
| `Rectangle(width=3, height=2)` | Rectangle |
| `RoundedRectangle(corner_radius=0.3)` | Rounded rect |
| `Triangle()` | Equilateral triangle |
| `Dot(point=ORIGIN)` | Small filled circle |
| `Line(start, end)` | Line segment |
| `Arrow(start, end)` | Arrow with tip |
| `DoubleArrow(start, end)` | Arrow on both ends |
| `DashedLine(start, end)` | Dashed line |
| `Polygon(*vertices)` | Arbitrary polygon |
| `Brace(mobject, direction=DOWN)` | Curly brace underneath a mobject |

### Data / Charts
| Class | Notes |
|-------|-------|
| `Axes(x_range=[0,10,1], y_range=[0,5,1])` | Cartesian axes |
| `NumberPlane()` | Full grid |
| `NumberLine(x_range=[0,10])` | Single axis |
| `BarChart(values, bar_names=[...])` | Vertical bar chart |
| `PieChart(values, slice_colors=[...])` | Pie chart (v0.18+) |

Plot a function on Axes:
```python
ax = Axes(x_range=[0, 2*PI, PI/2], y_range=[-1.5, 1.5])
curve = ax.plot(lambda x: np.sin(x), color=YELLOW)
self.play(Create(ax), Create(curve))
```

Plot discrete data:
```python
ax = Axes(x_range=[0, 5], y_range=[0, 100])
dots = VGroup(*[Dot(ax.c2p(i, v), color=RED) for i, v in enumerate(values)])
```

### Grouping
```python
group = VGroup(obj1, obj2, obj3)   # arrange/animate together
group.arrange(RIGHT, buff=0.5)      # layout: RIGHT, DOWN, UP, LEFT
group.arrange_in_grid(rows=2)
```

## Positioning

```python
obj.move_to(ORIGIN)          # absolute position
obj.shift(RIGHT * 2 + UP)    # relative offset
obj.next_to(other, DOWN, buff=0.3)  # relative to another object
obj.to_edge(LEFT)            # pin to screen edge
obj.to_corner(UL)            # pin to corner: UL, UR, DL, DR

# Align
obj.align_to(other, LEFT)    # match left edge
```

Direction constants: `UP`, `DOWN`, `LEFT`, `RIGHT`, `ORIGIN`,
`UL`, `UR`, `DL`, `DR`, `IN`, `OUT`

## Animations

### Intro / Outro
| Animation | Effect |
|-----------|--------|
| `Create(obj)` | Draw shape/line progressively |
| `Write(text)` | Write text stroke by stroke |
| `FadeIn(obj)` | Fade in (optionally `shift=UP`) |
| `FadeOut(obj)` | Fade out |
| `GrowFromCenter(obj)` | Scale in from center |
| `GrowFromPoint(obj, point)` | Scale in from a specific point |
| `SpinInFromNothing(obj)` | Spin while scaling in |

### Transform
| Animation | Effect |
|-----------|--------|
| `Transform(a, b)` | Morph `a` into `b` (keeps `a` in scene) |
| `ReplacementTransform(a, b)` | Morph and replace |
| `TransformFromCopy(a, b)` | Morph copy of `a` into `b` |

### Movement & Emphasis
| Animation | Effect |
|-----------|--------|
| `MoveAlongPath(obj, path)` | Move along a VMobject path |
| `Indicate(obj)` | Pulse highlight |
| `Circumscribe(obj)` | Draw circle/rectangle around obj |
| `Flash(point)` | Burst of lines from point |
| `Wiggle(obj)` | Wobble |
| `ApplyWave(obj)` | Wave distortion |

### Numbers
```python
num = DecimalNumber(0, num_decimal_places=1)
self.play(ChangeDecimalValue(num, 100), run_time=3)

# Integer counter
counter = Integer(0)
self.play(ChangeDecimalValue(counter, 50))
```

### Simultaneous animations
```python
self.play(FadeIn(a), FadeOut(b), run_time=2)  # play together
self.play(AnimationGroup(Create(a), Write(b), lag_ratio=0.3))
```

## Colors

Named constants: `RED`, `BLUE`, `GREEN`, `YELLOW`, `ORANGE`, `PURPLE`,
`GOLD`, `TEAL`, `PINK`, `WHITE`, `BLACK`, `GRAY`, `DARK_GRAY`, `LIGHT_GRAY`

Shades: `RED_A` through `RED_E` (A=lightest, E=darkest), same for all colors.

Hex: `color=ManimColor("#1f77b4")`

```python
obj.set_color(BLUE)
obj.set_fill(color=BLUE, opacity=0.5)
obj.set_stroke(color=WHITE, width=2)
```

## Camera & Background

```python
self.camera.background_color = "#1a1a2e"  # dark background
# or
config.background_color = WHITE           # set globally at top of file
```

For zooming/panning, subclass `MovingCameraScene`:
```python
class MyScene(MovingCameraScene):
    def construct(self):
        self.camera.frame.scale(0.5)           # zoom in 2x
        self.play(self.camera.frame.animate.move_to(obj))
```

## Timing

```python
self.play(Create(obj), run_time=2.0)   # slow down animation
self.wait(1.5)                          # hold frame for 1.5s
self.wait_until(lambda: ...)            # wait for condition
```

Rate functions (easing):
```python
from manim import rate_functions
self.play(Create(obj), rate_func=rate_functions.ease_in_out_cubic)
# also: linear, smooth, rush_into, rush_from, there_and_back
```

## Common Patterns

### Labeled value reveal
```python
label = Text("Revenue: ", font_size=32)
value = DecimalNumber(0, num_decimal_places=0, unit="M")
group = VGroup(label, value).arrange(RIGHT)
self.play(Write(label))
self.play(ChangeDecimalValue(value, 4.7), run_time=2)
```

### Animated bar chart from data
```python
values = [23, 45, 12, 67, 34]
names = ["A", "B", "C", "D", "E"]
chart = BarChart(
    values=values,
    bar_names=names,
    y_range=[0, 80, 10],
    bar_colors=[BLUE, TEAL, GREEN, YELLOW, RED],
)
self.play(Create(chart))
# Animate bar growth from zero:
self.play(chart.animate.change_bar_values([0]*5))
self.play(chart.animate.change_bar_values(values))
```

### Step-by-step bullet list
```python
bullets = VGroup(*[Text(f"• {s}", font_size=28) for s in items])
bullets.arrange(DOWN, aligned_edge=LEFT, buff=0.3)
for bullet in bullets:
    self.play(FadeIn(bullet, shift=RIGHT * 0.3))
    self.wait(0.5)
```

### Number line with pointer
```python
nl = NumberLine(x_range=[0, 100, 10], length=10, include_numbers=True)
pointer = Arrow(DOWN, ORIGIN, buff=0).next_to(nl.n2p(0), UP)
self.play(Create(nl), GrowFromCenter(pointer))
self.play(pointer.animate.next_to(nl.n2p(72), UP), run_time=2)
```
