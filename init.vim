" ======================================================================
"            _                                              _            _   
" _ ____   _(_)_ __ ___    _ __   ___  _ __ _ __ ___   __ _| |  ___  ___| |_ 
"| '_ \ \ / / | '_ ` _ \  | '_ \ / _ \| '__| '_ ` _ \ / _` | | / __|/ _ \ __|
"| | | \ V /| | | | | | | | | | | (_) | |  | | | | | | (_| | | \__ \  __/ |_ 
"|_| |_|\_/ |_|_| |_| |_| |_| |_|\___/|_|  |_| |_| |_|\__,_|_| |___/\___|\_                                                                           
" ======================================================================
"let mapleader=" "
"行号
set number 
" 相对行号
set relativenumber

" 突出显示当前行
set cursorline

set mousemoveevent

" 突出显示当前列
" set cursorcolumn

" 启用鼠标
set mouse =a
" set selection=exclusive
set selectmode=mouse,key

" 关闭vi兼容（一部分插件需要关闭此兼容）
set nocompatible

" 忽略大小写
set ignorecase
" 智能大小写
set smartcase

" vim-devicons需求
set encoding=UTF-8

" 设置行号左侧信号列自动出现 并使其为3列（可以同时显示三个不同等信号）
set signcolumn=auto:2

" 颜色设置
set termguicolors

" j/k上下移动时保留上下5行内容
set scrolloff=5
set sidescrolloff=5

" 时延时间 用于与which-key配合使用
set timeoutlen=300

" tab相关设置
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" 关闭左下方--插入--的模式显示，lightline已有显示该内容
set noshowmode

set completeopt=menu,menuone,noselect
"=========================================================================
"
" _ __ ___  _   _   _ __ | |_   _  __ _ 
"| '_ ` _ \| | | | | '_ \| | | | |/ _` |
"| | | | | | |_| | | |_) | | |_| | (_| |
"|_| |_| |_|\__, | | .__/|_|\__,_|\__, |
"           |___/  |_|            |___/ 
"==========================================================================
call plug#begin('/Users/bytx/.local/share/nvim/plugged')

" 注释插件
Plug 'tpope/vim-commentary'

" 历史记录树
" Plug 'mbbill/undotree'

" 修改文本环绕
Plug 'tpope/vim-surround'

" 重复插件，用于重复surround.vim
Plug 'tpope/vim-repeat'

" 文本预定义转化插件
Plug 'AndrewRadev/switch.vim'

" 自动括号匹配 
" Plug 'jiangmiao/auto-pairs'
" 代码片段扩展
Plug 'SirVer/ultisnips'
Plug 'BYTX-zyh/vim-snippets'

" 欢迎界面修改
Plug 'mhinz/vim-startify'

" 下方状态栏美化插件
Plug 'itchyny/lightline.vim'

call plug#end()

lua require('plugins')
lua require('init')
lua require('dap-go').setup()


source ~/.config/nvim/config/keymap.vim
source ~/.config/nvim/config/ultisnips.vim
source ~/.config/nvim/config/theme.vim
"lightline配置
" 详细高级配置查看：https://github.com/itchyny/lightline.vim#advanced-configuration

" vim-startify  
" 详细config查看：https://github.com/mhinz/vim-startify/wiki/Example-configurations
" vim-startify 设置开头内容
 let g:startify_custom_header =
       \ startify#pad(split(system('figlet -w 100 BYTX - NEOVIM'), '\n'))

" 启用语法隐藏
 set conceallevel=2


" 自动保存折叠信息
augroup remember_folds
  autocmd!
  autocmd BufWinLeave ?* mkview
  autocmd BufWinEnter ?* silent! loadview
augroup END

" 打开文件时跳转到上次编辑位置`
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") |   exe "normal! g'\"" | endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END 
endi
" ==========================================================================
" 调用figlet生成大字符画 large character
noremap tx :r !figlet 

"=========================================================================
"当前键盘配置描述
" normal模式 tx 调用figlet生成大字符画
"==========================================================================================
" 关于插件的一些信息
" ____  _             _         ___        __       
"|  _ \| |_   _  __ _(_)_ __   |_ _|_ __  / _| ___  
"| |_) | | | | |/ _` | | '_ \   | || '_ \| |_ / _ \ 
"|  __/| | |_| | (_| | | | | |  | || | | |  _| (_) |
"|_|   |_|\__,_|\__, |_|_| |_| |___|_| |_|_|  \___/ 
"               |___/                               
" =========================================================================================
" vim-surround https://github.com/tpope/vim-surround#surroundvim 
" doc : https://github.com/tpope/vim-surround/blob/master/doc/surround.txt
" TODO : doc没有看 
" "Hello world!"     cs"'(change surround " ')      --> 'Hello world!'
" 'Hello world!'     cs'<q>(change surround ' <q>)  --> <q>Hello world!</q>
"  <q>Hello world!</q>  cst"(change surround tag ") --> "Hello world!"   (此时cs<q>"是无法使用的，只能使用cst)
"  "Hello world!"  ds"（delete surround ")          --> Hello world!
"  TODO: 以下部分没有分析 需要 text-objects 基础查看此插件
"  Now with the cursor on "Hello", press ysiw] (iw is a text object).  [Hello] world! 
"  Let's make that braces and add some space (use } instead of { for no space): cs]{ --> { Hello } world! 
"  Now wrap the entire line in parentheses with yssb or yss). --> ({ Hello } world!) 
"  Revert to the original text: ds{ds) --> Hello world! 
"  Emphasize hello: ysiw<em>  --> <em>Hello</em> world! 
"  Finally, let's try out visual mode. Press a capital V (for linewise visual mode) followed by S<p class="important">. 
"  <p class="important">
"  <em>Hello</em> world!
"  </p>
"
" ===========================================================================================
"
" switch.vim : https://github.com/AndrewRadev/switch.vim 
" 通过`:Switch`命令进行转化，或者使用预设定义的键`gs`。
" 或者修改gs为其他映射：`let g:switch_mapping =""` （设置为空即取消映射）
" `:SwitchReverse`翻转转化 
" switch的转化需要保证光标在匹配字符串上。
" 当出现多个匹配情况时，只执行最短的匹配内容，参考下例子：
" 假设定义了如下switch { :foo => true } switches into: { foo: true } 
" 如果光标位于 `:foo =>`中的某个部分则可以成功进行转化，如果光标位于true。则只会进行true --> false
" 
"
" switch函数：
" 除了使用命令switch之外也可以使用switch函数进行调用，以下两个操作是等价的：
" :call switch#Switch() equivalent to:  :Switch 
" 也可给出reverse参数进行使用：
" :call switch#Switch({'reverse': 1})  or, :call switch#Switch({'reverse': v:true})
" equivalent to:   :SwitchReverse
" 该函数成功时返回1，失败时返回0，可以据此避免一些映射的冲突，如下例所示：
"
"" Don't use default mappings
"let g:speeddating_no_mappings = 1
"" Avoid issues because of us remapping <c-a> and <c-x> below
"nnoremap <Plug>SpeedDatingFallbackUp <c-a>
"nnoremap <Plug>SpeedDatingFallbackDown <c-x>
"
"" Manually invoke speeddating in case switch didn't work
"nnoremap <c-a> :if !switch#Switch() <bar>
"      \ call speeddating#increment(v:count1) <bar> endif<cr>
"nnoremap <c-x> :if !switch#Switch({'reverse': 1}) <bar>
"      \ call speeddating#increment(-v:count1) <bar> endif<cr>
"
" 通过对函数返回的判定，可以使两个功能集合在同一键盘映射上 
"
"
" switch_custom_definitions:可以通过g:switch_definitions或者
" b:switch_custom_definitions分别定义全局或者当前缓冲区的自定义switch。
" 例如如下：
" let g:switch_custom_definitions =
"    \ [
"    \   ['foo', 'bar', 'baz']
"    \ ]
" 将会在foo\bar\baz中循环转化。
" 当然可能会有对于字母大小写的需求，例如true,True,TRUE等。可以使用这些函数来进行修饰：
" switch#NormalizedCase  
" switch#Words
" switch#NormalizedCaseWords 
"let g:switch_custom_definitions =
"    \ [
"    \   switch#NormalizedCase(['one', 'two']),
"    \   switch#Words(['three', 'four']),
"    \   switch#NormalizedCaseWords(['five', 'six']),
"    \ ]
" 经过上述设置后，第一个函数将保留其格式进行转化，one-two ONE-TWO One-Two 
" 第二个函数只会在three与four之间转化，即会出现Three->four->three的转化情况  
" 第三个函数只会转化纯大/小写情况。
" 
"
" 尽管switch已经拥有默认映射，仍然可以自定义一些新的映射例如：
" let g:variable_style_switch_definitions = [
"      \   {
"      \     '\<[a-z0-9]\+_\k\+\>': {
"      \       '_\(.\)': '\U\1'
"      \     },
"      \     '\<[a-z0-9]\+[A-Z]\k\+\>': {
"      \       '\([A-Z]\)': '_\l\1'
"      \     },
"      \   }
"      \ ]
"nnoremap + :call switch#Switch({'definitions': g:variable_style_switch_definitions})<cr>
"nnoremap - :Switch<cr>
"
"通过上述定义可以在按下+ 时自动转化变量样式，而按下-时进行内置的调用。
"
"
" TODO: dict 定义与Nested dict定义 https://github.com/AndrewRadev/switch.vim#dict-definitions 

" commentary.vim https://github.com/tpope/vim-commentary 
"
" gc{motion} --> 将{motion}移动的内容注释/取消注释
" gcc --> 注释/取消注释[connt]lines 
" {Visual}gc --> 注释/取消注释选中的行
" gc --> (Text object for a comment (operator pending mode only.))
" gcgc(gcu) --> 取消当前行及其附近的注释行的注释（即取消段注释）
" :[range]Commentary --> 注释/取消注释 [range]范围 
