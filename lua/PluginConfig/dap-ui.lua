local dap = require("dap")

local dapui = require("dapui")
-- 初始化调试界面
dapui.setup(
    {
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t"
        },
        --  允许展开行超过当前Windows 需要nvim>0.7
        expand_lines = vim.fn.has("nvim-0.7"),

        -- layouts 定义用于放置窗口的屏幕部分
        -- position 参数可以为 "left", "right", "top" or "bottom"
        -- size 指定高度/宽度。可以为绝对值，也可以为百分比
        -- elements 是布局中显示的元素（按照顺序）
        -- layout 按照顺序打开，故越靠前的在窗口大小设置中拥有更高的优先权
        layouts = {
            {
                elements = {
                    -- elements可以是带有id和size的字符串或者table
                    { id = "scopes", size = 0.25 },
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40,
                position = "right",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 0.25,
                position = "bottom",
            },
        },

        controls = {
            --  需要 Neovim nightly ( 0.8 when released)
            enabled = true,

            -- Display controls in this element
            element = "repl",

            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "↻",
                terminate = "□",
            },
        },

        floating = {
            max_height = nil, -- 可以为int或者0-1之间的浮点数，浮点数表示百分比占比
            max_width = nil,
            border = "single", -- 边框样式  Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
        render = {
            max_type_length = nil, -- Can be integer or nil.
            max_value_lines = 100, -- Can be integer or nil.
        }
    }
)

-- 自动打开与关闭dap-ui
-- local debug_open = function()
--     dapui.open()
--     vim.api.nvim_command("DapVirtualTextEnable")
-- end
-- local debug_close = function()
--     dap.repl.close()
--     dapui.close()
--     vim.api.nvim_command("DapVirtualTextDisable")
--     -- vim.api.nvim_command("bdelete! term:")   -- close debug temrinal
-- end

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     debug_open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     debug_close()
-- end
-- dap.listeners.before.event_exited["dapui_config"]     = function()
--     debug_close()
-- end
-- dap.listeners.before.disconnect["dapui_config"]       = function()
--     debug_close()
-- end
-- require("dapui").open()
-- require("dapui").close()
-- require("dapui").toggle()
