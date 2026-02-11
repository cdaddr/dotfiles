#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def yellow; "\e[33m#{self}\e[0m" end
  def un_dot; self.sub(/^\./, '') end
end

HOME = ENV['HOME']
DOTFILES_DIR = File.expand_path(File.dirname(__FILE__))

PATHS = %w[
  .config/aliases.sh
  .config/bash
  .config/bat
  .config/dircolors
  .config/eza
  .config/ghostty
  .config/git
  .config/ideavim
  .config/irb
  .config/jj
  .config/kitty
  .config/lazygit
  .config/nvim
  .config/p10k.zsh
  .config/powerlevel10k
  .config/prettierdrc.toml
  .config/tmux
  .config/wezterm
  .config/zsh
  .config/current-theme-env.zsh
  .config/current-theme.lua
  .config/LS_COLORS.sh
  .hushlogin
  .zshrc
]

conflicts = PATHS.filter_map do |path|
  target_path = File.join(HOME, path)
  target_path if File.exist?(target_path) && !File.symlink?(target_path)
end

if conflicts.any?
  puts "Conflicts found! Remove these before running install:".red
  conflicts.each { |path| puts "  #{path}".yellow }
  exit 1
end

PATHS.each do |path|
  source_path = File.join(DOTFILES_DIR, path.un_dot)
  target_path = File.join(HOME, path)
  FileUtils.mkdir_p(File.dirname(target_path))
  FileUtils.ln_sf(source_path, target_path)
  puts "Linked #{target_path}".green
end

puts "Setup complete!".green

