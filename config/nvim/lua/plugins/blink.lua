highlight = function(ctx)
  if ctx.source_name ~= "Path" then
    return ctx.kind_hl
  end

  local is_unknown_type = vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
  local mini_icon, mini_hl =
    require("mini.icons").get(is_unknown_type and "os" or ctx.item.data.type, is_unknown_type and "" or ctx.label)
  return mini_icon ~= nil and mini_hl or ctx.kind_hl
end

return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-space>"] = { "show", "hide", "fallback" },
      -- because of auto-show and auto-select, it will eat <esc> trying to get out of normal mode
      -- ...so leave this off
      -- ["<Esc>"] = { "hide", "fallback" },
      ["<M-s>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
      ["<M-l>"] = {
        function(cmp)
          cmp.show({ providers = { "lsp" } })
        end,
      },

      ["<M-p>"] = {
        function(cmp)
          cmp.show({ providers = { "path" } })
        end,
      },

      ["<C-e>"] = { "hide" },
      ["<C-y>"] = { "select_and_accept" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-d>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-u>"] = { "select_prev", "fallback" },

      ["<f1>"] = { "show_signature", "hide_signature" },
      ["<f2>"] = { "show_documentation", "hide_documentation" },

      ["<S-up>"] = { "scroll_documentation_up", "fallback" },
      ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
      ["<S-down>"] = { "scroll_documentation_down", "fallback" },
      ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = {
      trigger = {
        show_in_snippet = false,
      },
      ghost_text = {
        enabled = false, -- disabled to allow ai completions
      },
      documentation = {
        auto_show = true,
      },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      menu = {
        auto_show = false, -- disabled to allow ai completions
        auto_show_delay_ms = 100,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                return kind_icon
              end,
              highlight = highlight,
            },
            kind = {
              highlight = highlight,
            },
          },
        },
      },
    },

    sources = {
      default = { "lazydev", "snippets", "path", "lsp", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        lsp = {
          fallbacks = {}, -- always show buffer comps
        },
        -- default is buffer's wd, I want cwd
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      },
    },

    cmdline = {
      enabled = false,
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        "exact",
        "score",
        "sort_text",
      },
    },
  },
  -- opts_extend = { "sources.default" },
}
