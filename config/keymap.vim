
" 按键映射 
"
let g:mapleader = ' '

"常规键映射
"dap 
"
" :help dap-mappings
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
" lua require('dapui').open()<CR> todo: 自动加载
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require 'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>

nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>


" telescope
"
" local builtin = require('telescope.builtin')
" vim.keymap.set('n', 'ff', builtin.find_files, {}) -- ff:文件查找
" vim.keymap.set('n', 'fg', builtin.live_grep, {}) -- fg:grep
" vim.keymap.set('n', 'fb', builtin.buffers, {}) -- fb: buffer
" vim.keymap.set('n', 'fh', builtin.help_tags, {}) fh :帮助
" vim.key

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fb <cmd>Telescope buffers<cr>
nnoremap fh <cmd>Telescope help_tags<cr>
nnoremap fw <cmd>Telescope which<cr>
