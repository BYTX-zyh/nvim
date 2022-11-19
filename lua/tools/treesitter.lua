
-- 用法： ：TSInstall xxx 安装某语言的依赖
local treesitter = {}

function treesitter.config()

require 'nvim-treesitter.configs'.setup {
    -- 启动时确保安装的language parser 没有安装的会自动安装
    ensure_installed = { "lua", "go", "c", "markdown", "vim" },

    auto_install = false, --打开没有高亮的文件时自动为其安装treesitter （需要确保有tree-sitter cli工具）
    -- ignore_install= {"txt"}, -- 不安装的语言插件

    -- 代码高亮
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false -- 关闭vim的高亮
    },
    -- 增量选择
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>', -- normal 模式 启动增量选择
            scope_incremental = '<CR>', -- normal 模式递增选择
            node_incremental = '<TAB>', -- visual 模式 递增选择
            node_decremental = '<S-TAB>', -- visual 模式 递减选择
        },
  },
    --自动添加关于等号的格式化
    indent = {
        enable = true
    }
}

-- 防止packer加载的treesitter发生故障，同时设置其为vim的折叠方式
-- vim.opt.foldmethod     = 'expr'
-- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
---WORKAROUND
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
        vim.opt.foldmethod = 'expr'
        vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
    end
})
---ENDWORKAROUND

-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 99

end


return treesitter
