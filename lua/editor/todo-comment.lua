-- 一些相关命令：
-- :todotelescope keywords=TODO,FIX 使用telescope进行查找
-- :TODOQuickFix 显示项目中所有的todos（使用quickfix list）
-- :TODOLocList  功能同上，采用location list

local todocomments = {}

function todocomments.config()
require("todo-comments").setup {
    signs         = true, -- 在侧边显示符号图标
    sign_priority = 8,    -- 符号优先级

    keywords = { -- 识别为todo comments的关键词
        FIX  = {
            icon  = "",                                 -- 用于显示的图标
            color = "error",                            -- 颜色，可以是hex值也可以是命名颜色
            alt   = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- 映射到此关键词的其他关键词集合
            signs = false,                              -- 分别为某些关键词单独配置符号
        },
        -- 个人配置中新增fin内容，并对其余高亮内容进行了一定对修改
        FIN  = {
            icon  = "", -- https://www.nerdfonts.com/cheat-sheet
            color = "#30dff3",
            alt   = { "FINFISH", "fin", "finish" },
        },
        TODO = {
            icon  = " ",
            color = "info",
            alt   = { "todo", "Todo" }
        },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "xxx", "warning" } },
        -- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", "info", "note" } },
        TEST = { icon = "ﭧ ", color = "test", alt = { "TESTING", "PASSED", "FAILED", "test" } },
    },
    gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- 如果为true则自定义关键字将与默认关键字合并

    -- 高亮显示todo comment所在的行
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
        before = "bg", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
        error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
        info    = { "DiagnosticInfo", "#2563EB" },
        hint    = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test    = { "Identifier", "#FF00FF" }
    },
    search = {
        command = "rg",
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
}
end

return todocomments
