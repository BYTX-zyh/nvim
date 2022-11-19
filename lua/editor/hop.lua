--[[
-- 常用指令：
--
-- 泛指命令：
-- Hop*AC : 在光标之前运行Hop*
-- Hop*BC : 在光标之后运行Hop*
-- Hop*CurrentLine : 在当前行执行Hop*
-- Hop*MW : 在所有可见buffer执行Hop*
-- 
-- 组合命令：
-- Hop*CurrentLineBC : 仅在光标之前和当前行上运行Hop*
-- Hop*CurrentLineAC ：仅在光标之后和当前行上运行Hop*
--
-- 普通命令：
-- HopChar1 : 要求输入一个char并显示所有带有此char的位置
-- HopChar2 : 输入两个char并显示匹配的跳转提示 如果按下第一个char以后直接回车则等同HopChar1
-- HopLine : 显示行跳转提示
-- HopLineStart : 显示行跳转，但是跳转位置是第一个非空字符
-- HopVertical : 显示行跳转提示，尽量保持光标的列位置相同
-- HopPattern : 与nvim搜索结合的匹配跳转提示
-- HopWord : 单词跳转
--
--]]


local hop  = {}

function hop.config()

    require("hop").setup{
        keys = 'etovxqpdygfblzhckisuran', -- hop表明跳转时使用的键
        quit_key = '<SPC>', -- 退出键
        jump_on_sole_occurrence = false, -- 如果hop提示只有一个内容则自动跳转，设为false
        uppercase_labels = true, -- 显示的字母为大写
        -- hint_position = require'hop.hint'.HintPosition.END, -- 跳转到结尾
    }
end


return hop
