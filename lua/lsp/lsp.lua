local lsp = {}

function lsp.config()
-- Mappings.
-- nvim-lspconfig作用为检测到匹配的文件类型时的lsp自动加载以及相关的分析显示
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- lsp图标定义
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}
-- 注册lsp图标
for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end




local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--
-- lua lsp配置
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
require('lspconfig').sumneko_lua.setup {
    -- on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                -- 对vim和use报错的忽略
                globals = { 'vim', "use" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },

}

-- clangd 配置
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
require 'lspconfig'.clangd.setup {
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {
    'clangd',
    '--background-index',
    '--suggest-missing-includes',
    '--clang-tidy',
    '--header-insertion=iwyu',
  },
}


require 'lspconfig'.gopls.setup {}

require 'lspconfig'.pyright.setup {}

end

return lsp

