#!/usr/bin/env bash
# Render a Manim scene to mp4.
#
# Usage:
#   render.sh <scene_file.py> [SceneClassName] [quality]
#
# Quality flags:
#   l = 480p15  (fast preview)
#   m = 720p30  (default, good for iteration)
#   h = 1080p60 (final quality for presentations)
#
# Output lands in:
#   media/videos/<scene_file>/<quality>/<SceneClassName>.mp4
#
# Examples:
#   render.sh animations/bar_chart.py BarChartScene
#   render.sh animations/bar_chart.py BarChartScene h

set -euo pipefail

PROJECT_DIR="/Users/tollef/Desktop/disputas/presentation-code"

FILE="${1:?Usage: render.sh <scene_file.py> [SceneClass] [quality]}"
SCENE="${2:-}"
QUALITY="${3:-m}"

cd "$PROJECT_DIR"

echo "Rendering: $FILE  scene=${SCENE:-<all>}  quality=$QUALITY"
uv run manim -q"$QUALITY" "$FILE" $SCENE

echo ""
echo "Output written to: $PROJECT_DIR/media/videos/"
