
require('plugins')


require('PluginConfig.dap-config')

require('PluginConfig.dap-ui')
require('PluginConfig.nvim-dap-virtual-text')
require("PluginConfig.which-key")
require("PluginConfig.which")
-- leader 设置位于keymaps故keymaps最先调用，早于其余需要使用的内容
require("keymap.keymap")
-- require("PluginConfig.cmp")
require("lsp.cmp")
require("ui.winbar")
