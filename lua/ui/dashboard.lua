local dashboard = {}

function dashboard.config()

    local db = require('dashboard')
    db.session_directory = vim.env.HOME .. '/.cache/nvim/session'
    -- 退出自动保存session
    db.session_auto_save_on_exit = true

    -- db.dashboard_custom_header = {
    --   '   ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣴⣶⣶⣶⣶⣶⠶⣶⣤⣤⣀⠀⠀⠀⠀⠀⠀ ',
    --   ' ⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⠁⠀⢀⠈⢿⢀⣀⠀⠹⣿⣿⣿⣦⣄⠀⠀⠀ ',
    --   ' ⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⠿⠀⠀⣟⡇⢘⣾⣽⠀⠀⡏⠉⠙⢛⣿⣷⡖⠀ ',
    --   ' ⠀⠀⠀⠀⠀⣾⣿⣿⡿⠿⠷⠶⠤⠙⠒⠀⠒⢻⣿⣿⡷⠋⠀⠴⠞⠋⠁⢙⣿⣄ ',
    --   ' ⠀⠀⠀⠀⢸⣿⣿⣯⣤⣤⣤⣤⣤⡄⠀⠀⠀⠀⠉⢹⡄⠀⠀⠀⠛⠛⠋⠉⠹⡇ ',
    --   ' ⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣼⣇⣀⣀⣀⣛⣛⣒⣲⢾⡷ ',
    --   ' ⢀⠤⠒⠒⢼⣿⣿⠶⠞⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⣼⠃ ',
    --   ' ⢮⠀⠀⠀⠀⣿⣿⣆⠀⠀⠻⣿⡿⠛⠉⠉⠁⠀⠉⠉⠛⠿⣿⣿⠟⠁⠀⣼⠃⠀ ',
    --   ' ⠈⠓⠶⣶⣾⣿⣿⣿⣧⡀⠀⠈⠒⢤⣀⣀⡀⠀⠀⣀⣀⡠⠚⠁⠀⢀⡼⠃⠀⠀ ',
    --   ' ⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣭⣭⣭⣭⣭⣥⣤⣤⣤⣴⣟⠁    ',
    -- }
    db.preview_command = 'cat | lolcat -F 0.3'
    -- db.preview_command = 'viu'
    -- db.preview_command = 'viu ~/Pictures/16e97308c2e942a28c68afb22a36023b.jpg'
    db.preview_file_path = '/Users/bytx/.config/nvim/static/neovim'
    -- db.preview_file_path = vim.env.HOME .. '/Pictures/16e97308c2e942a28c68afb22a36023b.jpg'
    db.preview_file_height = 10
    db.preview_file_width = 90
    db.custom_center = {
        {
            icon = '  ',
            desc = 'Recently latest session                  ',
            shortcut = 'SPC s l',
            action = 'SessionLoad'
        },
        {
            icon = '  ',
            -- icon_hl = { fg = z.yellow },
            desc = 'Recently opened files                   ',
            action = 'Telescope oldfiles',
            shortcut = '<SPC> f o',
        },

        {
            icon = '  ',
            -- icon_hl = { fg = z.cyan },
            desc = 'Find  File                              ',
            action = 'Telescope find_files find_command=rg,--hidden,--files',
            shortcut = 'SPC f f',
        },
        {
            icon = '  ',
            -- icon_hl = { fg = z.oragne },
            desc = 'Find  word                              ',
            action = 'Telescope live_grep',
            shortcut = 'SPC f g',
        },
        {
            icon     = '  ',
            -- icon_hl = { fg = z.red },
            desc     = 'Update Plugins                          ',
            shortcut = 'SPC p u',
            action   = 'PackerUpdate',
        },

    }
    -- 保存session前关闭nvimtree
    vim.api.nvim_create_autocmd('User', {
        pattern = 'DBSessionSavePre',
        callback = function()
            ---@diagnostic disable-next-line: param-type-mismatch
            pcall(vim.cmd, 'NvimTreeClose')
        end,
    })
end

return dashboard
