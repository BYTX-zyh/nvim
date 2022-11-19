require('which').setup {

    keymaps = {
        { 'xc', ':echo "1"<CR>', description = 'Toggle comment', mode = { 'n', 'v' } },
    },
    commands = {
        -- {
        --     "Test",
        --     "echo '????why'",
        --     description = "测试",
        -- },

        { ':Dothing', exec = ":echo 'thing'"
            , description = 'how Do something!'
        },
        {
            ':Dewtest',
            exec = ":echo 'unfinishtest'",
            description = "?",
            unfinished = true,
            bind = true,
        }
    }
}
