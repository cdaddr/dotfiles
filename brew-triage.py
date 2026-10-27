#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///
# sort packages installed outside the Brewfile into Brewfile.common or
# Brewfile.<host>. prompts per entry; edits the files but never commits.

import re
import subprocess
import tempfile
from pathlib import Path

DOTFILES = Path(__file__).parent.resolve()
HOST = subprocess.run(["hostname", "-s"], capture_output=True, text=True).stdout.strip()
COMMON = DOTFILES / "Brewfile.common"
HOSTFILE = DOTFILES / f"Brewfile.{HOST}"

LINE = re.compile(r'^(tap|brew|cask|uv|go|npm|cargo|mas|vscode)\s+"([^"]+)"(.*)$')

def entries(text):
    out = {}
    for line in text.splitlines():
        m = LINE.match(line.strip())
        if m:
            kind, name, opts = m.groups()
            out[(kind, name)] = opts.strip()
    return out

def short(name):
    return name.split("/")[-1]

def dump():
    with tempfile.TemporaryDirectory() as d:
        path = Path(d) / "Brewfile"
        subprocess.run(["brew", "bundle", "dump", f"--file={path}", "--force"], check=True)
        return entries(path.read_text())

# formulas that are (recursive) dependencies of something tracked are not drift
def dependency_names(tracked_formulas):
    r = subprocess.run(["brew", "deps", "--installed"], capture_output=True, text=True)
    deps = set()
    for line in r.stdout.splitlines():
        name, _, rest = line.partition(":")
        if short(name) in tracked_formulas:
            deps.update(short(d) for d in rest.split())
    return deps

tracked = entries(COMMON.read_text())
if HOSTFILE.exists():
    tracked |= entries(HOSTFILE.read_text())
installed = dump()

tracked_short = {(k, short(n)) for k, n in tracked}
tracked_formulas = {short(n) for k, n in tracked if k == "brew"}
deps = dependency_names(tracked_formulas)

new = sorted(
    (k, n, opts) for (k, n), opts in installed.items()
    if (k, short(n)) not in tracked_short
    and k != "tap"
    and not (k == "brew" and short(n) in deps)
)
missing = sorted((k, n) for (k, n) in tracked if (k, short(n)) not in {(k, short(n)) for k, n in installed} and k != "tap")

if missing:
    print(f"tracked but not installed here ({len(missing)}); run ./setup.py to install:")
    for k, n in missing:
        print(f"  {k:5} {n}")
    print()

if not new:
    print("nothing untracked.")
    raise SystemExit(0)

print(f"installed but untracked ({len(new)}):")
print("  c = add to Brewfile.common   h = add to Brewfile.%s   s = skip   q = quit\n" % HOST)
for k, n, opts in new:
    line = f'{k} "{n}"' + (f", {opts.lstrip(', ')}" if opts else "")
    while True:
        ans = input(f"  {line}  [c/h/s/q] ").strip().lower()
        if ans in ("c", "h", "s", "q"):
            break
    if ans == "q":
        break
    if ans == "s":
        continue
    target = COMMON if ans == "c" else HOSTFILE
    with target.open("a") as f:
        f.write(line + "\n")
    print(f"    -> {target.name}")

print("\nreview with `jj diff`; commit when happy.")
