vim.g.mapleader = ' '
-- hop
-- todo: hop 指令映射
vim.keymap.set({ 'n' }, '<leader>hl', '<Cmd>:HopLine<CR>', { desc = "hopline 所有  行跳转" })
vim.keymap.set({ 'n' }, '<leader>hla', '<Cmd>:HopLineAC<CR>', { desc = "HopLineAC 光标前 行跳转" })
vim.keymap.set({ 'n' }, '<leader>hlb', '<Cmd>:HopLineBC<CR>', { desc = "HopLineBC 光标后 行跳转" })
vim.keymap.set({ 'n' }, '<leader>hw', '<Cmd>:HopWord<CR>', { desc = 'HopWord 单词跳转' })
vim.keymap.set({ 'n' }, '<leader>hwa', '<Cmd>:HopWordAC<CR>', { desc = 'HopWord 光标后 单词跳转' })
vim.keymap.set({ 'n' }, '<leader>hwb', '<Cmd>:HopWordBC<CR>', { desc = 'HopWord 光标前 单词跳转' })

-- telescope
vim.keymap.set('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = "find files" })
vim.keymap.set('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = "live_grep" })
vim.keymap.set('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', { desc = "buffers" })
vim.keymap.set('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = "help" })
vim.keymap.set('n', '<leader>fo', '<Cmd>Telescope oldfiles<CR>', { desc = 'oldfiles' })
vim.keymap.set('n', '<leader>fc', '<Cmd>Telescope command_history<CR>', { desc = "command_history" })

-- todo-comments
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
end, { desc = "Next error/warning todo comment" })


-- toggleterm
-- <C-\> 终端显示与切换
--
--
--   treesitter
--   v            tab     增量选择范围增大
--   v            S-tab   增量选择范围减少
--
-- nmap <buffer> J <plug>UndotreeNextState
--
-- undo-tree
vim.keymap.set("n", '<M-1>', "<Cmd>UndotreeToggle<CR>", { desc = "切换undotree状态" })


-- load session
vim.keymap.set('n', '<leader>sl', '<Cmd>SessionLoad<CR>', { desc = 'load session' })
