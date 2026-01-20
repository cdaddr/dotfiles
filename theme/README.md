# Themes

This script sets up themes for nvim, zsh, and other tools using templates.

## HOWTO

- Create a theme definition `theme/colors-*.json`.
- Run `ruby theme/generate-theme.rb <path-to-colors-json>`.

## Theme Definition Format

`theme/colors-*.json` format:

```json
{
  "colors": {
    "primary": "#7aa2f7",
    "path": "#ff9e64",
    ...
  },
  "wezterm": "Tokyo Night",
  "nvim": "tokyonight",
  "vivid": "tokyonight",
  ...
}
```

> [!NOTE]
> The same theme for different tools might have a different spelling, spacing, capitalization etc. which is why we specify them separately per tool.  Also some themes don't exist for some tools at all.


## What it does

- Creates a `.zsh` file that `zshrc` will source, to set up environment variables that set the theme for some tools.
- Creates a `.lua` file that lua-based configs (nvim, wezterm) can source; then they can access the colour palette directly.
- Creates a ZSH syntax-highlighting file and an oh-my-posh theme using a template and subbing in colour names.

