#!/usr/bin/env ruby

require "fileutils"
require "open3"

DOTFILES = File.expand_path(__dir__)
$errors = []

# helpers

BLUE  = "\e[34m"
GREEN = "\e[32m"
RED   = "\e[31m"
RESET = "\e[0m"

def section(title)
  puts "#{BLUE}* #{title}#{RESET}"
  yield
  puts
end

def ok(msg)
  puts("#{GREEN}  - #{msg}#{RESET}")
end

def fail(msg)
  $errors << msg
  puts("#{RED}  - [error] #{msg}#{RESET}")
end

def run(label, *cmd)
  _, _, status = Open3.capture3(*cmd)
  if status.success?
    ok(label)
  else
    fail("#{label} (run manually to debug: #{cmd.join(" ")})")
  end
end

def symlink(src, target)
  if File.symlink?(target)
    return if File.readlink(target) == src
    File.delete(target)
  elsif File.exist?(target)
    fail("Conflict: #{target} exists and is not a symlink — remove it to fix: rm -rf #{target}")
    return
  end
  FileUtils.mkdir_p(File.dirname(target))
  FileUtils.ln_s(src, target)
  ok(target)
end

# homebrew

section("homebrew") do
  run("brew bundle", "brew", "bundle", "--file=#{DOTFILES}/Brewfile")
end

# symlinks

section("symlinks ~/.config/*") do
  FileUtils.mkdir_p(File.join(ENV["HOME"], ".config"))
  Dir.children("#{DOTFILES}/config").each do |name|
    symlink("#{DOTFILES}/config/#{name}", "#{ENV["HOME"]}/.config/#{name}")
  end
end

section("symlinks dotfiles") do
  {
    "#{DOTFILES}/zshrc"            => "#{ENV["HOME"]}/.zshrc",
    "#{DOTFILES}/hushlogin"        => "#{ENV["HOME"]}/.hushlogin",
    "#{DOTFILES}/claude/CLAUDE.md" => "#{ENV["HOME"]}/.claude/CLAUDE.md",
  }.each { |src, target| symlink(src, target) }
end

# nvim providers

section("nvim providers") do
  venv_base = "#{ENV["HOME"]}/.local/share/venv"
  FileUtils.mkdir_p(venv_base)

  venv_python = "#{venv_base}/neovim-python"
  _, _, s1 = Open3.capture3("uv", "venv", "--clear", venv_python)
  _, _, s2 = Open3.capture3("uv", "pip", "install", "--python", "#{venv_python}/bin/python", "pynvim")
  if s1.success? && s2.success?
    ok("python (pynvim)")
  else
    fail("python provider (uv venv / pynvim)")
  end

  ruby_bin, _, status = Open3.capture3("rv", "ruby", "find")
  if status.success?
    ruby_bin = File.dirname(ruby_bin.strip)
    run("ruby (neovim gem)", "#{ruby_bin}/gem", "install", "neovim")
  else
    fail("ruby provider — rv ruby find failed (is a ruby installed via rv?)")
  end
end

section("nvim lsp") do
  run("rubocop",  "rv", "tool", "install", "rubocop")
  run("ruby-lsp", "rv", "tool", "install", "ruby-lsp")
  run("ruff", "uv", "tool", "install", "ruff")
  run("node", "volta", "install", "node")
  %w[
    bash-language-server
    vscode-langservers-extracted
    prettier
    sql-formatter
    svelte-language-server
    @tailwindcss/language-server
    @vtsls/language-server
    yaml-language-server
  ].each { |pkg| run(pkg, "volta", "install", pkg) }
end

# drift check

section("homebrew drift") do
  unlisted, _, _ = Open3.capture3("brew", "bundle", "cleanup", "--file=#{DOTFILES}/Brewfile")
  if unlisted.strip.empty?
    ok("no unlisted packages")
  else
    indented = unlisted.strip.lines.map { |l| "    #{l.chomp}" }.join("\n")
    fail("packages not in Brewfile (run 'brew bundle cleanup --file=#{DOTFILES}/Brewfile --force' to remove):\n#{indented}")
  end
end

# report

if $errors.empty?
  puts "#{BLUE}* done#{RESET}"
else
  puts "#{BLUE}#{$errors.size} issue(s):#{RESET}"
  $errors.each { |e| puts "#{RED}  - #{e}#{RESET}" }
  exit 1
end
