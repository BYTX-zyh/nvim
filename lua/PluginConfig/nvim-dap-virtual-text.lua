require("nvim-dap-virtual-text").setup {
    enabled = true, -- 启用此插件（默认true）
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- 高亮发生变化的变量值
    highlight_new_as_changed = false, -- 以与上一个项目（高亮变化变量）相同的高亮方式高亮新出现的变量
    show_stop_reason = true, --因异常停止时显示其原因
    commented = false, -- 使用注释格式显示virtual text
    only_first_definition = true, -- 仅在第一次定义是显示virtual text(如果有多个)
    all_references = true, -- 在变量的所有引用上显示，而非只显示在变量定义上
    filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
    -- experimental features:
    virt_text_pos = 'eol', -- 虚拟文本的位置, see `:h nvim_buf_set_extmark()`
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- 显示虚拟行而非虚拟文本(将会闪烁) 不建议修改此内容 可能会导致插件崩溃 原因未知
    -- 将虚拟文本位置固定的参数  position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    virt_text_win_col = nil,
}
