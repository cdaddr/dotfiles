#!/bin/sh
# open a short full-width window along the bottom of the current tab (splits layout)
lines=${1:-5}
id=$(kitten @ launch --cwd=last_reported --location=hsplit)
kitten @ action layout_action move_to_screen_edge bottom
# resizing can land a line off, so measure and adjust twice
for _ in 1 2; do
  cur=$(kitten @ ls --match "id:$id" | sed -n 's/.*"lines": \([0-9]*\).*/\1/p' | head -1)
  [ "$cur" = "$lines" ] || kitten @ resize-window --match "id:$id" --axis vertical --increment $((lines - cur))
done
