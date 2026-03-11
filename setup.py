#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///

import os
import subprocess
from contextlib import contextmanager
from pathlib import Path

DOTFILES = Path(__file__).parent.resolve()
HOME = Path.home()

BLUE  = "\033[34m"
GREEN = "\033[32m"
RED   = "\033[31m"
RESET = "\033[0m"

errors = []

@contextmanager
def section(title):
    print(f"{BLUE}* {title}{RESET}")
    yield
    print()

def ok(msg):
    print(f"{GREEN}  - {msg}{RESET}")

def fail(msg):
    errors.append(msg)
    print(f"{RED}  - [error] {msg}{RESET}")

def run(label, *cmd):
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode == 0:
        ok(label)
    else:
        fail(f"{label} (run manually to debug: {' '.join(cmd)})")

def symlink(src, target):
    src, target = Path(src), Path(target)
    if target.is_symlink():
        if Path(os.readlink(target)) == src:
            ok(str(target))
            return
        target.unlink()
    elif target.exists():
        fail(f"Conflict: {target} exists and is not a symlink — remove it to fix: rm -rf {target}")
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    target.symlink_to(src)
    ok(str(target))

# homebrew

with section("homebrew"):
    run("brew bundle", "brew", "bundle", f"--file={DOTFILES}/Brewfile")

# symlinks

with section("symlinks"):
    (HOME / ".config").mkdir(exist_ok=True)
    for name in os.listdir(DOTFILES / "config"):
        symlink(DOTFILES / "config" / name, HOME / ".config" / name)

    for src, target in {
        DOTFILES / "zshrc":            HOME / ".zshrc",
        DOTFILES / "hushlogin":        HOME / ".hushlogin",
        DOTFILES / "claude/CLAUDE.md": HOME / ".claude/CLAUDE.md",
    }.items():
        symlink(src, target)

# nvim providers

with section("nvim providers"):
    venv_base = HOME / ".local/share/venv"
    venv_base.mkdir(parents=True, exist_ok=True)

    venv_python = venv_base / "neovim-python"
    r1 = subprocess.run(["uv", "venv", "--clear", str(venv_python)], capture_output=True)
    r2 = subprocess.run(["uv", "pip", "install", "--python", str(venv_python / "bin/python"), "pynvim"], capture_output=True)
    if r1.returncode == 0 and r2.returncode == 0:
        ok("python (pynvim)")
    else:
        fail("python provider (uv venv / pynvim)")

    r = subprocess.run(["rv", "ruby", "find"], capture_output=True, text=True)
    if r.returncode == 0:
        ruby_bin = Path(r.stdout.strip()).parent
        run("ruby (neovim gem)", str(ruby_bin / "gem"), "install", "neovim")
    else:
        fail("ruby provider — rv ruby find failed (is a ruby installed via rv?)")

# nvim lsp

with section("nvim lsp"):
    run("rubocop",  "rv", "tool", "install", "rubocop")
    run("ruby-lsp", "rv", "tool", "install", "ruby-lsp")
    run("ruff", "uv", "tool", "install", "ruff")
    run("node", "volta", "install", "node")
    for pkg in [
        "bash-language-server",
        "vscode-langservers-extracted",
        "prettier",
        "sql-formatter",
        "svelte-language-server",
        "@tailwindcss/language-server",
        "@vtsls/language-server",
        "yaml-language-server",
    ]:
        run(pkg, "volta", "install", pkg)

# drift check

with section("homebrew drift"):
    r = subprocess.run(
        ["brew", "bundle", "cleanup", f"--file={DOTFILES}/Brewfile"],
        capture_output=True, text=True,
    )
    unlisted = r.stdout.strip()
    if not unlisted:
        ok("no unlisted packages")
    else:
        indented = "\n".join(f"    {line}" for line in unlisted.splitlines())
        fail(f"packages not in Brewfile (run 'brew bundle cleanup --file={DOTFILES}/Brewfile --force' to remove):\n{indented}")

# report

if not errors:
    print(f"{BLUE}* done{RESET}")
else:
    print(f"{BLUE}{len(errors)} issue(s):{RESET}")
    for e in errors:
        print(f"{RED}  - {e}{RESET}")
    raise SystemExit(1)
