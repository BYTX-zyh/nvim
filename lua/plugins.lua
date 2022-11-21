-- vim.cmd [[packadd packer.nvim]]
-- 自动加载packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function()

    use { 'wbthomason/packer.nvim' }
    --           _ _ _
    --   ___  __| (_) |_ ___  _ __
    --  / _ \/ _` | | __/ _ \| '__|
    -- |  __/ (_| | | || (_) | |
    --  \___|\__,_|_|\__\___/|_|
    --
    -- 时间增强工具，增强<C-A> <C-X> 对于时间的变化
    -- 时间格式查看 :SpeedDatingFormat
    use { 'tpope/vim-speeddating' }
    -- 增强显示tab与空格、回车以及当前所在块
    use { "lukas-reineke/indent-blankline.nvim",
     config = require("editor.indent-blankline").config()
}

    -- 缓冲区内部快速跳转
    -- todo:keymap
    use {
        'phaazon/hop.nvim',
        config = require("editor.hop").config()
    }
    -- todo、fin等注释内容高亮
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = require("editor.todo-comment").config(),
    }
    -- 查找增强插件
    use { 'kevinhwang91/nvim-hlslens',
    config = require('editor.hlslens').config() }
    -- -- -- 文本对齐工具
    use { 'godlygeek/tabular' }
    -- -- _   _ ___
    -- | | | |_ _|
    -- | | | || |
    -- | |_| || |
    -- \___/|___|
    -- -- light
    use { 'cocopon/iceberg.vim' }
    use { 'arcticicestudio/nord-vim' } -- 无区分，只有暗色
    use { 'rakr/vim-one' } -- light/dark
    use { 'NLKNguyen/papercolor-theme' } -- light/dark
    use { 'folke/tokyonight.nvim' } -- 除day

    -- 启动界面
    use { 'glepnir/dashboard-nvim' ,
    config = require("ui.dashboard").config()
    }

    -- use { 'mhinz/vim-startify',
    -- config= vim.cmd('source ~/.config/nvim/lua/ui/vim-startify.vim')
    -- }



    -- -- 键映射提示
    use { "folke/which-key.nvim", }

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        -- run = ':TSUpdate',
        config = require("tools.treesitter").config()
    }
    -- todo:详细配置 查看https://github.com/glepnir/nvim/blob/f15d7782217b9031433fde22b9807957c5bfb976/lua/modules/editor/config.lua
    use { 'nvim-treesitter/nvim-treesitter-textobjects' }

    -- 浮动窗口显示终端
    use { "akinsho/toggleterm.nvim",
        tag = '*',
        config = require("tools.toggleterm").config(),
    }


    -- -- dap
    use { 'mfussenegger/nvim-dap' }
    use { 'rcarriga/nvim-dap-ui' }
    use { 'theHamsta/nvim-dap-virtual-text' }
    use { 'leoluz/nvim-dap-go' }

    use { '~/code/solo/which.nvim' }

    -- _              _
    -- | |_ ___   ___ | |___
    -- | __/ _ \ / _ \| / __|
    -- | || (_) | (_) | \__ \
    -- \__\___/ \___/|_|___/

    -- https://github.com/nvim-tree/nvim-tree.lua
    -- 树形文件目录工具
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = require("tools.nvimtree").config()
    }

    -- vim中文文档
    use { 'yianwillis/vimcdoc' }

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim'
        } },
        config = require("tools.telescope").config(),
    }
    -- -- telescope 对 ultisnips 的扩展
    use { 'fhill2/telescope-ultisnips.nvim' }

    -- -- mason lsp、dap等内容等综合下载管理器
    use { "williamboman/mason.nvim",
        config = require("tools.mason").config()
    } --对于dap、lsp等需要外部包的一些服务的包管理插件

    -- -- 显示基于lsp的报错信息 todo: 配置
    use { 'folke/trouble.nvim' }

    -- -- undotree 文件历史树
    -- use { 'mbbill/undotree.vim' }
    use { 'mbbill/undotree' }

    -- lsp
    use {'neovim/nvim-lspconfig',
    config = require('lsp.lsp').config()
    } -- Configurations for Nvim LSP
    -- lsp快捷键与功能定义
    use {
        'glepnir/lspsaga.nvim',
        config = require('lsp.lspsaga').config()
    }
    use { 'hrsh7th/cmp-nvim-lsp' } --lsp上下文提示
    use { 'hrsh7th/cmp-buffer' } -- buffer上下文
    use { 'hrsh7th/cmp-path' } -- 路径补全
    use { 'hrsh7th/cmp-cmdline' }
    use { 'hrsh7th/nvim-cmp' } -- 补全框架主体
    use { 'f3fora/cmp-spell' } --拼写
    use { 'quangnguyen30192/cmp-nvim-ultisnips' }

end)
