-- 关于支持的语言与对应dap安装配置方法：
-- https://github.com/mfussenegger/nvim-dap#supported-languages
--

local dap = require("dap")


local dap_breakpoint = {
    error = {
        -- text = "🧘🛑⊚⭕🟢🔵🚫👉⭐️⛔️🔴",
        text = "🔴",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "👉",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)


-- lldb-vecode调试配置
dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- 此处必须为绝对路径（lldb-vscode会出现在llvm安装中，如果没有该文件安装/更新llvm
    name = 'lldb'
}


-- codelldb 调试配置
local cmd = os.getenv("HOME") .. "/.local/share/nvim/plugged/vimspector/gadgets/macos/CodeLLDB/adapter/codelldb"

dap.adapters.codelldb = function(on_adapter)
    -- This asks the system for a free port
    local tcp = vim.loop.new_tcp()
    tcp:bind("127.0.0.1", 0)
    local port = tcp:getsockname().port
    tcp:shutdown()
    tcp:close()

    -- Start codelldb with the port
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local opts = {
        stdio = { nil, stdout, stderr },
        args = { "--port", tostring(port) }
    }
    local handle
    local pid_or_err
    handle, pid_or_err =
    vim.loop.spawn(
        cmd,
        opts,
        function(code)
            stdout:close()
            stderr:close()
            handle:close()
            if code ~= 0 then
                print("codelldb exited with code", code)
            end
        end
    )
    if not handle then
        vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
        stdout:close()
        stderr:close()
        return
    end
    vim.notify("codelldb started. pid=" .. pid_or_err)
    stderr:read_start(
        function(err, chunk)
            assert(not err, err)
            if chunk then
                vim.schedule(
                    function()
                        require("dap.repl").append(chunk)
                    end
                )
            end
        end
    )
    local adapter = {
        type = "server",
        host = "127.0.0.1",
        port = port
    }
    -- 💀
    -- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
    -- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
    vim.defer_fn(
        function()
            on_adapter(adapter)
        end,
        500
    )
end

-- cpp 调试配置
dap.configurations.cpp = {
    {
        name = "lldb Launch file",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = false, -- 开始调试时暂停在入口处，如果出现问题可以考虑修改为false

        -- 提供输入参数
        -- args = function()
        -- local input = vim.fn.input("Input args: ")
        -- return require("user.dap.dap-util").str2argtable(input)
        -- end,
        args = {},
        runInTerminal = true, -- 可以出现终端内容
    },

    {
        name = "codelldb Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },

}

-- 令rust、cpp、c采用相同配置
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
