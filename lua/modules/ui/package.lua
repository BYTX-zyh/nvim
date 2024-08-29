local conf = require('modules.ui.config')

packadd({
  'nvimdev/dashboard-nvim',
  event = 'UIEnter',
  config = conf.dashboard,
})

packadd({
  'nvimdev/modeline.nvim',
  event = 'BufEnter */*',
  config = function()
    require('modeline').setup()
  end,
})

packadd({
  'lewis6991/gitsigns.nvim',
  event = 'BufEnter */*',
  config = conf.gitsigns,
})

packadd({
  'nvimdev/indentmini.nvim',
  event = 'BufEnter */*',
  config = function()
    require('indentmini').setup({
      only_current = true,
    })
  end,
})

packadd({
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
})

packadd({
  'rcarriga/nvim-notify',
  event = 'UIEnter',
})

packadd({
  'onsails/lspkind.nvim',
  config = conf.lspkind,
})
