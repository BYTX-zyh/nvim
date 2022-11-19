local wk = require("which-key")

wk.setup {
    plugins = {
        marks     = false, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling  = {
            enabled = false, --enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- 提示的条数
        },
        -- 预设插件，为neovim默认的键绑定添加帮助
        -- 并不创建键绑定
        presets   = {
            operators    = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions      = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows      = false, -- default bindings on <c-w>
            nav          = false, -- misc bindings to work with windows
            z            = false, -- bindings for folds, spelling and others prefixed with z
            g            = false, -- bindings for prefixed with g
        },
    },
    -- 添加触发motion和text object的内容
    -- 要启用所有操作符需要修改上面的 preset/operators
    operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    motions = {
        count = false,
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- 绑定在弹窗中向下滚动
        scroll_up   = '<c-u>', -- 绑定在弹窗中向上滚动
    },
    window = {
        border   = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin   = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding  = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"}                                           -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by deafult for Telescope
    disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
    },
}

-- wk.register({
--     f = {
--         name = "+file",
--         f = { "<cmd>Telescope find_files<cr>", "Find File" },
--         r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--         n = { "<cmd>enew<cr>", "New File" },
--     },
-- })

-- vim 命令： operator  motions
