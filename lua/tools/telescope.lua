--[[ 
<C-n>/<Down> -- 下一个项目
<C-p>/<Up>  --上一个项目
j/k --下/上一个 normal
H/M/L --选择高/中/低 normal
gg/G --选择第一个/最后一个项目 normal
<CR> --确认选择
<C-x> --以水平拆分的形式转到选择的文件
<C-v> --以垂直拆分的形式转到选择的文件
<C-t> --转到新选项卡中的文件 在新选项卡中打开选中的文件
<C-u> --预览窗口中向上滚动
<C-d> --预览窗口中向下滚动
<c-/> --显示选择器操作的映射（insert模式）
? --显示选择器操作的映射（normal模式）
<C-c> --关闭telescope
<Ese> -- 关闭telescope（normal模式）
<Tab> --切换选择并移动到下一个选择
<S-Tab> --切换选择并移动到上一个选择
<C-q> --将所有未过滤的项目发送到快速修复列表
<M-q> --将所有选定选项发送到qflist
--]]
-- 键映射
--
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', 'ff', builtin.find_files, {}) -- ff:文件查找
-- vim.keymap.set('n', 'fg', builtin.live_grep, {}) -- fg:grep
-- vim.keymap.set('n', 'fb', builtin.buffers, {}) -- fb: buffer
-- vim.keymap.set('n', 'fh', builtin.help_tags, {}) -- fh :帮助

local telescope = {}

function telescope.config() 

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
require('telescope').setup {
    defaults = {
        -- 默认的telescope配置，形式如下： config_key = value,
        mappings = {
            -- 该部分keymap用于唤出telescope窗口后使用
            i = {
                -- ["<C-q>"] = actions.which_key,-- C-q唤出which-key

                ["<C-c>"] = actions.close, -- C-c退出telescope
                -- ["<C-u>"] = false, -- C-u  清除提示，而非滚动预览
                ["<M-p>"] = action_layout.toggle_preview, -- 切换预览器
                -- 修改c-j c-k为移动
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,

                -- 切换搜索历史
                  ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                -- ["<M-j>"] = actions.preview_scrolling_up,
                -- ["<M-k>"] = actions.preview_scrolling_down,
            },

            n = {
                -- [ "C-w" ] =actions.which_key,
                -- ["<M-p>"] = action_layout.toggle_preview,-- 切换预览器
            }
        },
        preview = {
            mime_hook = function(filepath, bufnr, opts)
                local is_image = function(filepath)
                    local image_extensions = { 'png', 'jpg' } -- Supported image formats
                    local split_path = vim.split(filepath:lower(), '.', { plain = true })
                    local extension = split_path[#split_path]
                    return vim.tbl_contains(image_extensions, extension)
                end
                if is_image(filepath) then
                    local term = vim.api.nvim_open_term(bufnr, {})
                    local function send_output(_, data, _)
                        for _, d in ipairs(data) do
                            vim.api.nvim_chan_send(term, d .. '\r\n')
                        end
                    end

                    vim.fn.jobstart(
                        {
                            'viu', filepath -- Terminal image viewer command
                        },
                        { on_stdout = send_output, stdout_buffered = true })
                else
                    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid,
                        "Binary cannot be previewed")
                end
            end
        },
    },
    --[[
  -- pickers 表示telescope中的筛选器，例如findfile、oldfiles、lsp等。  
  -- https://github.com/nvim-telescope/telescope.nvim#pickers
--]]
    pickers = {
        -- 默认的配置格式如下：
        -- picker_name = {
        --   picker_config_key = value,
        -- ...
        -- }
        find_files = {
            -- theme = "dropdown",
            find_command = {"fd"},
        },
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    }
}

--
require('telescope').load_extension('ultisnips')
require('telescope').load_extension('which')

end

return telescope

