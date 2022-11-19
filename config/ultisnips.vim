" =========================================================================================================
" ultisnips : https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt 
"  中文非官方翻译：https://github.com/Linfee/ultisnips-zh-doc/blob/master/doc/UltiSnips_zh.txt 
" 需要关闭vi兼容与拥有python支持。
"
"在插件目录下创建`filetype.snippets`以编写对应文件的代码片段，`all.snippets`将适配于所有的文件类型。
" 使用ultisnipedit指令对对应文件进行编辑
"

"定义了编辑窗口如何打开，其值包括有：normal(默认、在当前窗口打开)、horizontal(水平分割)、vertical(垂直分割)、context(水平或者垂直，依赖于具体环境) 
let g:UltiSnipsEditSplit = 'context' 

"g:UltiSnipsSnippetsDir
"定义了自定义代码片段存放的位置,需要指向到github仓库/UltiSnips 
let g:UltiSnipsSnippetDirectories = ["~/.local/share/nvim/plugged/vim-snippets/UltiSnips"]
"
"
"触发键映射默认值：根据文档Using your own trigger functions
" 将键映射修改为只有可以触发时才进行触发，而其他时间可以执行其原来的效果


let g:UltiSnipsExpandTrigger ='<c-t>'  " 展开匹配的snip
let g:UltiSnipsListSnippets   ='<S-TAB>' " 显示snip列表
let g:UltiSnipsJumpForwardTrigger ='<c-j>' " 跳转到前一个匹配项
let g:UltiSnipsJumpBackwardTrigger ='<c-k>' " 跳转到后一个匹配项



" let g:ulti_expand_or_jump_res = 0 "default value, just set once
"    function! Ulti_ExpandOrJump_and_getRes()
"      call UltiSnips#ExpandSnippetOrJump()
"      return g:ulti_expand_or_jump_res
"    endfunction
" inoremap <NL> <TAB>=(Ulti_ExpandOrJump_and_getRes() > 0)?"":IMAP_Jumpfunc('', 0)<CR>

"
"  代码片段语法格式 
"  
"  # 表示注释内容
"  snippet tab_trigger [ "description" [ options ] ]
"  # code
"  endsnippet
"
" tab_trigger 是必须的，但 description 和 opotions 是可选的
" 'tab_trigger'为用来触发片段的单词或字符串 如果tab_trigger中存在空格，使用""包裹tab_trigger
" description为注释描述
" option为扩展选项: 扩展选项可以为如下部分的组合：
" b 关键词出现在行首时可被展开（可存在空格、tab），即触发词前为空白即可 
" i 在单词中展开 - 默认只有在触发器是一行的第一个单词或者它被放在空白字符之间才能被展开。有这个选项的片段会忽略触发器被放在哪。也就是说，片段可以在一个单词中间被触发展开。
" w 单词边界 - 使用了这个选项，只有在触发器的开始和结束处都位于单词边界，才能
"   被展开。也就是说触发器必须放在一个非单词字符后面。单词字符由 'iskeyword'
"   设置。使用这个选项的一个例子，当触发器在一个标点符号后面，这个标点符号不是
"   另一个触发器的最后字符，这个触发器可以被展开(如果这个片段使用了这个选项)。
" r 正则表达式 - 使用这个选项，触发器应当是一个python的正则表达式。正则表达式必须被引号括起来(或者用其他字符包裹)不论它是否包含空格。匹配的结果会作为本地变量"match"传递给片段中的任何python代码。
" t 不要展开制表符 - 如果一个片段定义中包括了领头的制表符，默认UltiSnips会根据vim的下列缩进设置来展开制表符 'shiftwidth', 'softtabstop', 'expandtab'和'tabstop'(比如说，如果设置了'expandtab'，制表符会被空格替代)，如果设置了这个选项，UltiSnips就会忽略vim的这些设置，插入制表符本身。
" s 在跳到下一个插入点前，立即移除行尾光标前的空白字符。如果在某一个插入点，在行尾有可选的文本，这将是很有用的。
" m 在一个片段中，减掉所有右边的空白字符。当片段中包含空行，并且需要在展开后也保持空。如果没有这个选项，在片段中的空行上将会有缩进字符。
" e 上下文片段 - 使用这个选项，片段的展开将不仅仅被前面的字符控制，还会被给出的python表达式控制。
" A 满足条件时自动触发
"
" 在片段的定义中，字符'`'，'}'，'$'，'\'有特殊意义，如果要插入这些字符，使用'\'来转义他们。
"
"
"VISUAL模式占位符：
"片段中可以包含一个特殊的占位符，叫做 ${VISUAL}。${VISUAL} 将会在展开的时候被替换展开之前选中的文本。

"插入点与占位符：
"插入点的语法是一个`$` 符号紧跟着一个数字，例如，`$1`。插入点遵循从一号开始然后按顺序排列，`$0`是一个特殊的插入点。不论有多少插入点被定义，它总是片段中的最后一个插入点。如果没有定义 `$0`，`$0`将默认被定义在片段的末尾。
"
"为一个插入点设置默认值常常是有用的。默认值可能是变量值常用的部分，或者是一个词或短语，提醒你这里应该输入什么。要插入默认值，语法是 `${1:value}`。
"
"镜像可以重复一个插入点的内容。在一个片段展开后，当你在一个插入点插入内容，该插入点的所有的镜像都会被同样的值替换。要给一个插入点做一个镜像，只需要再插入这个插入点一次，使用 $ 符号并跟上一个数字的语法，例如，'$1'
"
"一个插入点的镜像可以有一个默认值。只需要第一个插入点有默认值，镜像插入点会自动拥有这个默认值。
"
"转化： 
"一个转化的语法：${<tab_stop_no/regular_expression/replacement/options} 
" tab_stop_no        - 要引用的插入点的编号
" regular_expression - 引用的插入点中和正则表达式匹配的内容
" replacement        - 替换字符串，下面详细说明
" options            - 正则表达式的选项
"
" 选项可以是下面几个字符的任何组合: >
   " g    - 全局替换
   "        默认情况下，只有第一个匹配正则表达式的部分会被替换。使用这个选项，所有
   "        匹配的内容都会被替换。
   " i    - 不区分大小写
   "        默认情况下，正则表达式匹配是大小写敏感的。使用这个选项，正则表达式的
   "        匹配将在忽略大小写的情况下完成。
   " m    - 多行模式
   "        默认情况下，'^'和'$'特殊字符仅引用于这个字符串的开始和结束。所以如果你
   "        选择了多行模式，转换将是把他们作为一个完整的单行字符串处理。使用这个选
   "        项，'^'和'$'特殊字符匹配一个字符串中的任何行的开始和结束(使
   "        换行符分隔 - '\n')
   "        By default, the '^' and '$' special characters only apply to the
   "        start and end of the entire string; so if you select multiple lines,
   "        transformations are made on them entirely as a whole single line
   "        string. With this option, '^' and '$' special characters match the
   "        start or end of any line within a string ( separated by newline
   "        character - '\n' ).
   " a    - ascii 转换
   "        默认情况下，转换在原始的utf-8编码下工作。使用这个选项，匹配将会在相应
   "        的 ASCII 字符中完成，例如，'à' 将会变成 'a'，这个选项需要python模块
   "        'unidecode'的支持
   "

" 替换字符串可以包含 $编号 的变量，例如，$1，表示正则表达式中的(匹配)组。$0 变量
" 是特殊的用来产生整个匹配。替换字符串也可以包括特殊的转义序列： >
"    \u   - 大写下一个字符
"    \l   - 小写下一个字符
"    \U   - 大写所有 \E 之前的字符
"    \L   - 小写所有 \E 值钱的字符
"    \E   - End upper or lowercase started with \L or \U
"    \n   - 一个新行
"    \t   - 一个换行符
" 最终，替换字符串可以包含有条件的替换，通过使用这样的语法(?no:text:other text)。
" 它的意思是，如果组 $编号 不匹配，就插入 "text"，否则插入"other text"。"other text"
" 是可选的，而且如果没有提供默认值就是空字符串，""。这个特性很强大。它允许你添加可
" 选的文本到片段中。
" 详细内容见演示 
