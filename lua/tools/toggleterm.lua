
--[[
调用命令：
:ToggleTerm size=40 dir=~/Desktop direction=horizontal 
:ToggleTermToggleAll 打开之前的所有终端，或者关闭所有打开的终端
:ToggleTermSendCurrentLine <T_ID> :: 发送光标所在的整行 <T_ID> 为可选参数，表示发送到的位置，默认为第一个终端
:ToggleTermSendVisualLines <T_ID> :: 发送visual模式选择的内容所在的行
:ToggleTermSendVisualSelection <T_ID> :: 发送visual模式选择的内容
:ToggleTermSetName :: 设置显示名称，主要用于winbar

使用openmappings切换显示与隐藏终端窗口，当前设置为 C-\
--]]

local toggleterm = {}

function toggleterm.config()
require("toggleterm").setup{
    -- size可以是指定数字也可以是给出的函数
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
open_mapping = [[<c-\>]],
        -- 一些关于创建、打开、输入、输出的触发内容
  -- on_create      = fun(t: Terminal), -- function to run when the terminal is first created
  -- on_open        = fun(t: Terminal), -- function to run when the terminal opens
  -- on_close       = fun(t: Terminal), -- function to run when the terminal closes
  -- on_stdout      = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
  -- on_stderr      = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
  -- on_exit        = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
  hide_numbers      = true, -- 在toggleterm buffers隐藏数字列（应当为行号列）
  -- shade_filetypes   = {},
  autochdir         = true, -- 当nvim更改当前目录时，下次打开终端会自动更改其目录
  start_in_insert   = true,
  insert_mappings   = true, -- open mapping 是否适用于 insert mode
  terminal_mappings = true, -- open mapping 是否适用于 opened terminals
  persist_size      = true,
  persist_mode      = true,        -- true 则会记住之前的terminal mode
direction       = 'float',     -- 'vertical' | 'horizontal' | 'tab' | 'float', 垂直 水平 tab 浮动
  close_on_exit     = true,        -- 进程退出时关闭终端窗口
  shell             = vim.o.shell, -- 更改默认
  auto_scroll       = true,        -- automatically scroll to the bottom on terminal output

        -- 当设置为float时生效的内容
  -- float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    -- like `size`, width and height can be a number or function which is passed the current terminal
    -- width = <value>,
    -- height = <value>,
    -- winblend = 3,
  -- },
        -- winbar设置，标题terminal name
  winbar = {
    enabled = false,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}
end

return toggleterm
