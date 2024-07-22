local conf = require('modules.editor.config')

packadd({
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  config = conf.telescope,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
  },
})

packadd({
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewFile' },
  build = ':TSUpdate',
  config = conf.nvim_treesitter,
})

--@see https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/507
packadd({
  'nvim-treesitter/nvim-treesitter-textobjects',
  ft = { 'c', 'rust', 'go', 'lua' },
  config = function()
    vim.defer_fn(function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = { query = '@class.inner' },
            },
          },
        },
      })
    end, 0)
  end,
})

packadd({
  'L3MON4D3/LuaSnip',
  -- follow latest release.
  version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = 'make install_jsregexp',
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { "/Users/bytx/.config/nvim/snippets" } })
    local ls = require('luasnip')
    local s = ls.snippet
    local sn = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local l = require("luasnip.extras").lambda
    local rep = require("luasnip.extras").rep
    local p = require("luasnip.extras").partial
    local m = require("luasnip.extras").match
    local n = require("luasnip.extras").nonempty
    local dl = require("luasnip.extras").dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local types = require("luasnip.util.types")
    local conds = require("luasnip.extras.conditions")
    local conds_expand = require("luasnip.extras.conditions.expand")

    vim.keymap.set({ 'i' }, '<C-K>', function()
      ls.expand()
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-L>', function()
      ls.jump(1)
    end, { silent = true })
    vim.keymap.set({ 'i', 's' }, '<C-J>', function()
      ls.jump(-1)
    end, { silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-E>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })

    require('luasnip').setup({
      keep_roots = true,
      link_roots = true,
      link_children = true,
      history = true,
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,

    })

    -- ls.add_snippets("lua", {
    --   s("test", {
    --     t("function test()"),
    --     i(1),
    --     t("end"),
    --   }), {
    --   type = "autosnippets",
    --   key = "all_auto",
    -- }
    -- })

    -- ls.add_snippets("c", {
    --   s("test", {
    --     t("void test() {"),
    --     i(1),
    --     t("}"),
    --   }),
    -- }, {
    --   type = "autosnippets",
    --   key = "all_auto",
    -- })
    ls.add_snippets("elixir", {
      s("el", fmt("<%= {} %>{}", { i(1), i(0) })),
      s("ei", fmt("<%= if {} do %>{}<% end %>{}", { i(1), i(2), i(0) })),
    })

    ls.add_snippets("all", {
      s("bbb", {
        t("function "),
      }),
      s("test", {
        t("function test()/n"),
        i(1),
        t("end"),
      })
    }, {
      type = "autosnippets",
      key = "all_auto",
    })
  end,
})

-- 12+2 +周六 14/16
-- 7/16
-- 体检
-- 笔 本 杯
