return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "show", "accept" },
      ["<C-space>"] = { "show", "accept" },
      ["<C-s>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
      -- ["<C-b>"] = {
      --  function(cmp)
      --    cmp.show({ providers = { "buffer" } })
      --  end,
      -- },
      -- ["<C-f>"] = {
      --  function(cmp)
      --    cmp.show({ providers = { "path" } })
      --  end,
      -- },
      ["<C-e>"] = { "hide" },
      ["<C-y>"] = { "select_and_accept" },
      -- ['<CR>'] = { 'accept', 'fallback' },
      -- ['<ESC>'] = { 'hide', 'fallback' },

      ["<Down>"] = { "select_next", "fallback" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-j>"] = { "select_next", "fallback_to_mappings" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-k>"] = { "select_prev", "fallback_to_mappings" },

      ["<C-K>"] = { "show_signature", "hide_signature", "fallback" },

      ["<S-up>"] = { "scroll_documentation_up", "fallback" },
      ["<S-down>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = {
      trigger = {
        show_in_snippet = false,
      },
      ghost_text = {
        enabled = true,
      },
      documentation = {
        draw = function(opts)
          if opts.item and opts.item.documentation and opts.item.documentation.value then
            local out = require("pretty_hover.parser").parse(opts.item.documentation.value)
            opts.item.documentation.value = out:string()
          end

          opts.default_implementation(opts)
        end,
      },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      menu = {
        auto_show = true,
      },
    },

    sources = {
      default = { "lazydev", "snippets", "lsp", "path", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        lsp = {
          fallbacks = {},
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
