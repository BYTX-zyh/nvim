-- nvim-tree
--
--git相关图标含义：
--    Icon indicates when a file is:
-- - ✗  unstaged or folder is dirty
-- - ✓  staged
-- - ★  new file
-- - ✓ ✗ partially staged
-- - ✓ ★ new file staged
-- - ✓ ★ ✗ new file staged and has unstaged modifications
-- - ═  merging
-- - ➜  renamed
--
-- 命令：
-- : NvimTreeOpen                : 打开nvimtree，接受可选路径参数
-- : NvimTreeClose               : 关闭
-- : NvimTreeToggle              : 打开或者关闭（翻转当前状态），接受可选路径参数
-- : NvimTreeFocus               : 如果关闭则打开，如果打开则聚焦
-- : NvimTreeRefresh             : 刷新
-- : NvimTreeCollapse            : 递归折叠nvim tree
-- : NvimTreeCollapseKeepBuffers : 递归折叠nvim tree 保留当前buffer
--
-- <CR>/o/左键双击 : 打开
-- <BS>            : 关闭当前打开的目录或者父目录
-- <C-e>           : 就地编辑（替换nvim-tree窗口显示
-- O               : 编辑
-- <C-]>           : cd光标所在目录
-- <C-x>           : 水平拆分打开文件split
-- <C-v>           : 垂直拆分打开文件vsplit
-- <C-t>           : tabnew 在新tab打开文件
-- <               : 导航到当前文件/目录的上一个同级
-- >               : 导航到当前文件/目录的下一个同级
-- P               : parent_node 光标移动到父节点位置
-- <TAB>           : 预览文件（光标停留在nvim-tree上）
-- K               : 导航到当前文件/目录的第一个同级
-- J               : 导航到当前文件/目录的最后一个同级
-- I               : 切换是否显示gitignore
-- H               : 切换是否显示dotfiles
-- U               : toggle_custom       toggle visibility of files/folders hidden via |filters.custom| option
-- R               : 刷新nvim-tree
-- a               : 创建新文件，以/结尾则创建新目录
-- d               : 删除文件（会弹出确认
-- D               : 使用gio命令删除文件，其会被移动到~/.local/share/Trash/file内，其信息存储在Trash/info内
-- r               : 重命名，显示原文件名
-- <C-r>           : 重命名文件，不显示原文件名
-- x               : 剪切,添加/删除 文件/目录 到剪切板
-- c               : 复制
-- p               : 粘贴
-- y               : 将名称复制到系统剪切板
-- Y               : 将相对路径复制到系统剪切板
-- gy              : 将绝对路径复制到系统剪切板
-- [e              : prev_diag_item      go to next diagnostic item
-- [c              : prev_git_item       go to next git item
-- ]e              : next_diag_item      go to prev diagnostic item
-- ]c              : next_git_item       go to prev git item
-- -               : 导航到当前文件/目录的父目录
-- s               : 使用系统默认的应用程序打开此内容
-- f               : 基于正则表达式匹配动态实时过滤节点
-- F               : 清除实时过滤器
-- q               : 关闭nvim tree窗口
-- W               : 折叠nvim-tree
-- E               : 展开整个nvim-tree
-- S               : 搜索,展开用户输入的路径
-- <C-k>           : 浮动窗口显示文件信息
-- g?              : 切换帮助
-- m               : 切换节点是否为书签
-- bmv             : 将所有书签节点移动到指定位置
-- 
local nvimtree = {}
function nvimtree.config()
    

-- 禁用netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- 启用高亮显示组
vim.opt.termguicolors = true

require("nvim-tree").setup({
    -- 在write后自动重载
    auto_reload_on_write = true,
    -- 如果启动参数为目录或空则自动打开nvim-tree并聚焦(为空时默认打开欢迎界面，不显示nvim-tree)
    open_on_setup = true,
    -- 如果启动参数为文件则自动打开并聚焦于nvim-tree
    open_on_setup_file = true,
    -- 光标在关闭的文件夹上时创建新文件，将创建在该文件夹内部
    create_in_closed_folder = true,
    -- 打开或者切换新tab时自动打开nvim tree
    open_on_tab = true,
    sort_by = "case_sensitive",
    -- 自动在bufenter nvim tree时刷新
    reload_on_bufenter = true,
    -- 在文件树上显示coc与lsp的diagnostics
    diagnostics = {
        enable = false,
        -- 在父级目录上显示标志
        show_on_dirs = true,
    },

    git = {
        enable = true,
        ignore = false, -- 不忽略.gitinore文件
    },

    view = {
        adaptive_size = true, -- 自动调整大小
        number = true, -- 显示行号
        relativenumber = true, -- 相对行号

        mappings = {
            custom_only = false, -- true则只使用用户定义快捷键，禁用默认快捷键
            list = {
                { key = "u", action = "dir_up" },
            },
        },
        -- 浮动窗口显示
        float = {
            enable = false,
            quit_on_focus_loss = true, -- 失去焦点自动退出
        },
    },
    -- 渲染
    renderer = {
        group_empty = true,
        highlight_git = true, -- 高亮git
        highlight_opened_files = 'name', -- 高亮打开的文件的名字
    },
    filters = {
        dotfiles = false, -- false表示 显示dotfiles
    },

        -- 回收站 
        trash = {
            cmd = "gio trash",
            require_confirm = true,
        }
})

end

return nvimtree
