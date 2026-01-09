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

def link_file(source_path, target_path)
  FileUtils.mkdir_p(File.dirname(target_path))

  if File.exist?(target_path) && !File.symlink?(target_path)
    backup_path = "#{target_path}.backup"
    puts "Backing up existing #{target_path} to #{backup_path}".yellow
    FileUtils.mv(target_path, backup_path)
  end

  FileUtils.ln_sf(source_path, target_path)
  puts "Linked #{source_path} to #{target_path}".green
end

%w[
  .config/aliases.sh
  .config/bat
  .config/dircolors
  .config/eza
  .config/fish
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
  .config/Brewfile
  .hushlogin
  .zshrc
].each do |path|
    source_path = File.join(DOTFILES_DIR, path.un_dot)
    target_path = File.join(HOME, path)
    link_file(source_path, target_path)
  end

puts "Setup complete!".green

