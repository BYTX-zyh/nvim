local lspsaga = {}

function lspsaga.config()

-- 一些快捷键的配置
local saga= require("lspsaga")
local keymap = vim.keymap.set

saga.init_lsp_saga{
-- Options with default value
-- "single" | "double" | "rounded" | "bold" | "plus"
    -- 边框样式
border_style = "single",
--the range of 0 for fully opaque window (disabled) to 100 for fully
--transparent background. Values between 0-30 are typically most useful.
    -- 背景透明度 0 不透明 100全透明
saga_winblend = 0,
-- when cursor in saga window you config these to move
    -- 光标在saga窗口时的移动
move_in_saga = { prev = '<C-p>',next = '<C-n>'},
-- Error, Warn, Info, Hint
-- use emoji like
-- { "🙀", "😿", "😾", "😺" }
-- or
-- { "😡", "😥", "😤", "😐" }
-- and diagnostic_header can be a function type
-- must return a string and when diagnostic_header
-- is function type it will have a param `entry`
-- entry is a table type has these filed
-- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
    -- 报错信息图标，分别为 error warn  info hint
diagnostic_header = { " ", " ", " ", "ﴞ " },
-- preview lines above of lsp_finder
preview_lines_above = 0,
-- preview lines of lsp_finder and definition preview
max_preview_lines = 10,
-- use emoji lightbulb in default
code_action_icon = "💡",
-- if true can press number to execute the codeaction in codeaction window
    -- 如果为true则可以使用数字快捷操作code action
code_action_num_shortcut = true,
-- same as nvim-lightbulb but async
code_action_lightbulb = {
    enable = true,
    enable_in_insert = true,
    cache_code_action = true,
    sign = true,
    update_time = 150,
    sign_priority = 20,
    virtual_text = true,
},
-- finder icons
finder_icons = {
  def = '  ',
  ref = '諭 ',
  link = '  ',
},
-- finder do lsp request timeout
-- if your project big enough or your server very slow
-- you may need to increase this value
    -- 请求超时时间设置 如果频繁超时则增大
finder_request_timeout = 1500,
    -- finder action 键映射
finder_action_keys = {
    open = {'o', '<CR>'},
    vsplit = 's',
    split = 'i',
    tabe = 't',
    quit = {'q', '<ESC>'},
},

code_action_keys = {
    quit = 'q',
    exec = '<CR>',
},

definition_action_keys = {
  edit = '<C-c>o',
  vsplit = '<C-c>v',
  split = '<C-c>i',
  tabe = '<C-c>t',
  quit = 'q',
},

rename_action_quit = '<C-c>',
rename_in_select = true,
-- 需要nightly
-- show symbols in winbar must nightly
-- in_custom mean use lspsaga api to get symbols
-- and set it to your custom winbar or some winbar plugins.
-- if in_cusomt = true you must set in_enable to false
    -- winbar 上方代码位置导航
symbol_in_winbar = {
    in_custom = true,
    enable = true,
    separator = ' ',
    show_file = true,
    -- define how to customize filename, eg: %:., %
    -- if not set, use default value `%:t`
    -- more information see `vim.fn.expand` or `expand`
    -- ## only valid after set `show_file = true`
    file_formatter = "",
        -- 点击支持
    click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
        local st = node.range.start
        local en = node.range['end']
        if button == "l" then
            if clicks == 2 then
                -- double left click to do nothing
            else -- jump to node's starting line+char
                vim.fn.cursor(st.line + 1, st.character + 1)
            end
        elseif button == "r" then
            if modifiers == "s" then
                print "lspsaga" -- shift right click to print "lspsaga"
            end -- jump to node's ending line+char
            vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then
            -- middle click to visual select node
            vim.fn.cursor(st.line + 1, st.character + 1)
            vim.cmd "normal v"
            vim.fn.cursor(en.line + 1, en.character + 1)
        end
    end,
},
-- show outline
show_outline = {
  win_position = 'right',
  --set special filetype win that outline window split.like NvimTree neotree
  -- defx, db_ui
  win_with = '',
  win_width = 30,
  auto_enter = true,
  auto_preview = true,
  virt_text = '┃',
        -- 跳转用键
  jump_key = 'o',
  -- auto refresh when change buffer
  auto_refresh = true,
},
-- custom lsp kind
-- usage { Field = 'color code'} or {Field = {your icon, your color code}}
custom_kind = {},
-- if you don't use nvim-lspconfig you must pass your server name and
-- the related filetypes into this table
-- like server_filetype_map = { metals = { "sbt", "scala" } }
    -- 不使用lsp-config配置的文件类型映射
server_filetype_map = {},
}


-- vim.g.mapleader = ' '
-- 关闭窗口通常为C-c
-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
-- 用于查找定义与实现 <C-t> 跳回原位置
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- 打开code action提示
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

-- Rename 重命名
keymap("n", "r", "<cmd>Lspsaga rename<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
-- 浮窗显示定义(可编辑) 支持c-t跳回
keymap("n", "pd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

-- Show line diagnostics
-- 显示当前行报错信息
keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

-- Show cursor diagnostic
-- 显示当前光标报错信息
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })


-- Diagnsotic jump can use `<c-o>` to jump back
-- 报错信息跳转 可以使用c-o跳回
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })

-- Outline
-- 显示侧边大纲
keymap("n","<leader>sol", "<cmd>LSoutlineToggle<CR>",{ silent = true })

-- Hover Doc
-- 显示文档
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

-- Float terminal
-- 浮动终端打开
-- keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })

-- if you want pass somc cli command into terminal you can do like this
-- open lazygit in lspsaga float terminal
-- lazygit
-- keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
-- close floaterm
-- 关闭浮动终端
-- keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
end

return lspsaga
