local cmp = require 'cmp'


local kind_icons = {
    Class = " ",
    Color = " ",
    Constant = "ﲀ ",
    Constructor = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = "",
    Folder = " ",
    Function = " ",
    Interface = "ﰮ ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = "",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
}

local source_names = {
    nvim_lsp    = "(LSP)",
    treesitter  = "(TS)",
    emoji       = "(Emoji)",
    path        = "(Path)",
    calc        = "(Calc)",
    cmp_tabnine = "(Tabnine)",
    ultiSnips   = "[Snip]",
    buffer      = "(Buffer)",
    spell       = "(Spell)",
}

cmp.setup({
    -- 一些提示内容的格式
    formatting = {
        -- 不同类型内容的提示符号
        format = function(entry, vim_item)
            -- kind表示类型提示符号
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            -- 来源提示符号
            vim_item.menu = source_names[entry.source.name]
            return vim_item
        end,
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    -- 弹出窗口样式
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    -- 快捷键
    mapping = cmp.mapping.preset.insert({
        -- 分别表示向下和向上滚动
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        -- 文档预览上下移动 <C-b> <C-f>
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        -- 不显示弹窗
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    -- nvim补全来源
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        {name = 'path'},
    }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- 搜索中对基于buffer进行提示
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmd中进行提示
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})



