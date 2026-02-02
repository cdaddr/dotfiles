#!/usr/bin/env ruby
# frozen_string_literal: true

# See README.md for purpose and usage.

require 'json'
require 'pathname'
require 'open-uri'

SCRIPT_DIR = Pathname.new(__FILE__).dirname
DOTFILES = SCRIPT_DIR
CONFIG = DOTFILES / 'config'
ZSH_CONFIG = CONFIG / 'zsh'
THEME_DIR = SCRIPT_DIR / 'theme'
TEMPLATE_DIR = THEME_DIR / 'template'

def usage
  puts <<~USAGE
    Usage: #{$PROGRAM_NAME} <theme-file.json>

    Generate all themed config files from a theme definition.

    Arguments:
      theme-file.json - Theme definition file (e.g., theme/colors-tokyonight.json)

    Generates:
      - theme/template/current-theme.omp.json          (Oh My Posh theme)
      - theme/template/current-syntax-highlighting.zsh (ZSH syntax highlighting)
      - config/current-theme.lua                   (Lua palette for nvim/wezterm)
      - config/current-theme-env.zsh               (Environment variables)
      - ~/.config/eza/theme.yml                    (eza theme symlink, if eza-themes repo exists)
      - ~/.config/ghostty/theme                    (ghostty theme)

    Example:
  USAGE

  if THEME_DIR.exist?
    theme_files = Dir[THEME_DIR / 'colors-*.json'].sort
    if theme_files.any?
      puts
      puts 'Available themes:'
      theme_files.each do |f|
        puts "  - #{f}"
      end
    end
  end

  exit 1
end

def generate_omp_theme(colors)
  template_file = TEMPLATE_DIR / 'omp-template.json'
  output_file = ZSH_CONFIG / 'current-theme.omp.json'

  template = JSON.parse(File.read(template_file))
  template['palette'].merge!(colors)

  File.write(output_file, JSON.pretty_generate(template))
  puts "- generated #{output_file}"
end

def generate_zsh_syntax(colors)
  template_file = TEMPLATE_DIR / 'zsh-syntax-template.zsh'
  output_file = ZSH_CONFIG / 'current-syntax-highlighting.zsh'

  template = File.read(template_file)

  colors.each do |name, value|
    template.gsub!("{{#{name}}}", value)
  end

  unreplaced = template.scan(/\{\{(\w+)\}\}/).flatten.uniq
  if unreplaced.any?
    puts "Warning: Unreplaced placeholders in ZSH syntax: #{unreplaced.join(', ')}"
  end

  File.write(output_file, template)
  puts "- generated #{output_file}"
end

def generate_lua_theme(colors, theme_names, theme_file)
  output_file = CONFIG / 'current-theme.lua'

  colors_lua = colors.map { |k, v| "  #{k} = \"#{v}\"" }.join(",\n")

  lua_content = <<~LUA
    -- #{theme_file}

    local M = {}

    -- Color palette
    M.colors = {
    #{colors_lua}
    }

    -- Theme names for different tools
    M.wezterm = "#{theme_names['wezterm']}"
    M.nvim = "#{theme_names['nvim']}"
    M.lualine = "#{theme_names['lualine']}"
    M.vivid = "#{theme_names['vivid']}"

    return M
  LUA

  File.write(output_file, lua_content)
  puts "- generated #{output_file}"
end

def generate_zsh_env(theme_names)
  output_file = CONFIG / 'current-theme-env.zsh'

  # Convert simple color numbers to escape codes if needed
  search_bg = theme_names['less_search_bg']
  search_fg = theme_names['less_search_fg']

  # If it's just a number, convert to 256-color escape code
  search_bg = "\\e[48;5;#{search_bg}m" if search_bg =~ /^\d+$/
  search_fg = "\\e[38;5;#{search_fg}m" if search_fg =~ /^\d+$/

  zsh_content = <<~ZSH
    export VIVID_THEME="#{theme_names['vivid']}"
    export EZA_THEME="#{theme_names['eza']}"
    export BAT_THEME="#{theme_names['bat']}"

    # LESS_TERMCAP for search highlighting in pagers
    export LESS_TERMCAP_so=$'#{search_bg}#{search_fg}'
    export LESS_TERMCAP_se=$'\\e[0m'
  ZSH

  File.write(output_file, zsh_content)
  puts "- generated #{output_file}"
end

def generate_eza_theme(theme_name)
  theme_file = CONFIG / 'eza/theme.yml'
  uri = "https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/#{theme_name}.yml"

  begin
    File.open(theme_file, 'w') do |local|
      local.write("# #{uri}\n\n")
      local.write(URI.open(uri).read)
    end
    puts "- generated #{theme_file}"
  rescue OpenURI::HTTPError => e
    puts "HTTP error fetching eza theme #{uri}: #{e}"
  rescue StandardError => e
    puts "Error fetching eza theme: #{e}"
  end
end

def generate_ghostty_theme(theme_names)
  theme_file = CONFIG / 'ghostty/theme'
  begin
    File.open(theme_file, 'w') do |f|
      f.puts "theme = #{theme_names['ghostty']}"
    end
    puts "- generated #{theme_file}"
  rescue e
    puts "Error generating ghostty theme: #{e}"
  end
end

def main
  usage if ARGV.length != 1

  theme_file = Pathname.new(ARGV[0])

  unless theme_file.exist?
    theme_file = Pathname.new(THEME_DIR / "#{ARGV[0]}.json")
    unless theme_file.exist?
      puts "Error: Theme file not found: #{theme_file}"
      exit 1
    end
  end

  theme_data = JSON.parse(File.read(theme_file))

  unless theme_data['colors']
    puts "Error: Theme file must have a 'colors' field"
    exit 1
  end

  colors = theme_data['colors']
  theme_names = theme_data.reject { |k, _| k == 'colors' }

  generate_omp_theme(colors)
  generate_zsh_syntax(colors)
  generate_lua_theme(colors, theme_names, theme_file)
  generate_zsh_env(theme_names)
  generate_eza_theme(theme_names['eza'])
  generate_ghostty_theme(theme_names['eza'])
end

main
