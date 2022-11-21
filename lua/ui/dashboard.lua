local dashboard = {}

function dashboard.config()

    local db = require('dashboard')
    db.session_directory = vim.env.HOME .. '/.cache/nvim/session'
    -- 退出自动保存session
    db.session_auto_save_on_exit = true

    db.preview_command = 'cat | lolcat -F 0.3'
    db.preview_file_path = '/Users/bytx/.config/nvim/static/neovim'
    db.preview_file_height = 10
    db.preview_file_width = 90
    db.custom_center = {
        {
            icon     = '  ',
            icon_hl  = { fg                                          = "#f2be45" },
            desc     = 'Recently latest session                 ',
            shortcut = '<SPC> s l',
            action   = 'SessionLoad'
        },
        {
            icon     = '  ',
            desc     = 'Recently opened files                   ',
            action   = 'Telescope oldfiles',
            shortcut = '<SPC> f o',
        },

        {
            icon     = '  ',
            desc     = 'Find  File                              ',
            action   = 'Telescope find_files find_command          = rg,--hidden,--files',
            shortcut = '<SPC> f f',
        },
        {
            icon     = '  ',
            desc     = 'Find  word                              ',
            action   = 'Telescope live_grep',
            shortcut = '<SPC> f g',
        },
        {
            icon     = '  ',
            desc     = 'Update Plugins                          ',
            shortcut = '<SPC> p u',
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
