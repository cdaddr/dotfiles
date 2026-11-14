-- see colorscheme.lua for highlights
-- deferred: completion engine; completion becomes available a beat after the UI
-- paints (this file sorts last, so it's near the end of the later() queue).
later(function()
  vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
    "https://github.com/rafamadriz/friendly-snippets",
  })

  local highlight = function(ctx)
    return "Comment"
  end

  local default_providers = { "lsp", "lazydev", "snippets", "path", "buffer" }

  -- <Tab>/<S-Tab> on a bullets.vim list item demote/promote it (deeper/shallower
  -- level, cycling the marker like >> / <<) wherever the cursor is on the line,
  -- instead of completing. Lines that aren't list items keep normal <Tab> behaviour.
  -- No cursor-position check on purpose: in the leading indent, a plain <Tab> only
  -- inserts whitespace (no marker change), and a plain <S-Tab> inserts a tab, so it
  -- indents instead of outdenting.
  -- This lives in blink's chain rather than a buffer-local map because blink rebinds
  -- <Tab> on InsertEnter, and a buffer map would only run as blink's fallback, i.e.
  -- never while the completion menu is open.
  -- The mapping is an expr map, so emit <Cmd> keys rather than editing directly.
  local function list_shift(cmd)
    return function()
      if not vim.tbl_contains(vim.g.bullets_enabled_file_types or {}, vim.bo.filetype) then
        return
      end
      local line = vim.api.nvim_get_current_line()
      if line:match("^%s*[-*+]%s") or line:match("^%s*%d+[.)]%s") then
        return vim.keycode("<Cmd>" .. cmd .. "<CR>")
      end
    end
  end

  ---@type blink.cmp.Config
  require("blink.cmp").setup({
    keymap = {
      preset = "none",
      ["<Tab>"] = { list_shift("BulletDemote"), "select_and_accept", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { list_shift("BulletPromote"), "snippet_backward", "fallback" },
      ["<C-space>"] = { "show", "hide", "fallback" },
      -- blink will eat <esc> trying to get out of normal mode
      -- ...so leave this off
      -- ["<Esc>"] = { "hide", "fallback" },
      ["<M-a>"] = {
        function(cmp)
          cmp.show({ providers = default_providers })
        end,
      },
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
      trigger = { show_in_snippet = false },
      ghost_text = { enabled = false },
      documentation = { auto_show = true },
      list = {
        selection = { preselect = true, auto_insert = true },
      },
      menu = {
        auto_show = true,
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
            kind = { highlight = highlight },
          },
        },
      },
    },

    sources = {
      default = default_providers,
      per_filetype = {
        sql = { "snippets", "buffer" },
        mysql = { "snippets", "buffer" },
        plsql = { "snippets", "buffer" },
      },
      providers = {
        snippets = {
          -- snippets rank last (LSP first); negative offset sinks them below
          -- lsp/lazydev/path/buffer regardless of fuzzy score
          score_offset = -100,
          opts = {
            -- block friendly-snippets svelte (targets svelte 4)
            filter_snippets = function(filetype, file)
              if filetype == "svelte" and file:match("friendly%-snippets.*svelte%.json") then
                return false
              end
              return true
            end,
          },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- lsp-adjacent (lua nvim API); keep just under real lsp
          score_offset = 90,
        },
        lsp = { fallbacks = {}, score_offset = 100 },
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

    cmdline = { enabled = false },

    -- signature help (textDocument/signatureHelp): shows the function signature
    -- with the active param highlighted, and for overloaded methods (e.g. C#)
    -- the active overload -- roslyn picks it from the args already typed. Toggle
    -- with <f1> (see keymap above) or it auto-shows on trigger chars like "(".
    -- Experimental in blink, hence disabled by default.
    signature = { enabled = true },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = { "exact", "score", "sort_text" },
    },
  })
end)
