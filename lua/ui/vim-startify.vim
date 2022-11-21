

" e: 创建新的空缓冲区
" i: 创建新空缓冲区并跳转到插入模式
" q: 退出
" b（buffer同一窗口打开)/s(split)/v(vspilt)/t(tab)
" 例如 b024打开编号0,2,4的内容
" :startify 重新打开开始界面
"       :SLoad       load a session    |startify-:SLoad|
"      :SSave[!]    save a session    |startify-:SSave|
"      :SDelete[!]  delete a session  |startify-:SDelete|
"      :SClose      close a session   |startify-:SClose|

" 启动界面列表内容
let g:startify_lists = [
\ { 'type': 'files', 'header': [' Files'] },
\ { 'type': 'sessions', 'header': [' Sessions'] },
\ { 'type': 'bookmarks', 'header': [' Bookmarks'] },
\ { 'type': 'commands', 'header': [' Commands'] },
\ ]


" 列出的文件数目
let g:startify_files_number = 5

" 保存session 前的操作
let g:startify_session_before_save = [ 'silent!tabdo NERDTreeClose']
