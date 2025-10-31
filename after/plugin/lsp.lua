local lspconfig = require('lspconfig')
local ThePrimeagenGroup = vim.api.nvim_create_augroup("ThePrimeagenGroup", {})
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp = require('cmp')
local catppuccin = require("catppuccin.palettes").get_palette("frappe")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        'tsserver', 'eslint', 'lua_ls', 'jsonls', 'tailwindcss', 'bashls', 'rust_analyzer'
    }
})

vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    float = {
        border = "rounded",
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
    },
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    signs = true,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local function open_window_for_definition()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result)
        if not result or vim.tbl_isempty(result) then
            vim.diagnostic.open_float(nil, { border = "rounded", source = true, scope = "line" })
            return
        end
        local loc = result[1]
        if not loc or not loc.uri then
            vim.diagnostic.open_float(nil, { border = "rounded", source = true, scope = "line" })
            return
        end
        local bufnr = vim.uri_to_bufnr(loc.uri)
        vim.fn.bufload(bufnr)
        local lines = vim.api.nvim_buf_get_lines(bufnr, loc.range.start.line, loc.range["end"].line + 1, false)
        local content = table.concat(lines, "\n")
        vim.lsp.util.open_floating_preview(vim.split(content, "\n"), "rust", {
            border = "rounded",
            focusable = true,
            max_width = 80,
            max_height = 20,
        })
    end)
end


vim.api.nvim_create_autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf, silent = true, noremap = true }

        vim.keymap.set("n", "gd", open_window_for_definition, opts)
        vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float(0, { scope = "line" }) end, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
    end
})

local servers = { 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'jsonls', 'tailwindcss', 'bashls' }
for _, server in ipairs(servers) do
    lspconfig[server].setup({
        on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end,
        capabilities = capabilities,
    })
end

local has_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
                Copilot = "", -- Copilot icon
            }
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
            vim_item.menu = ({
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
                buffer = "[BUF]",
                path = "[PATH]",
            })[entry.source.name]
            return vim_item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp', group_index = 2 },
        { name = 'buffer', group_index = 2 },
        { name = 'path', group_index = 2 },
    }),
    sorting = {
        priority_weight = 2,
        comparators = {
            has_copilot_cmp and copilot_cmp.prioritize or nil,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = catppuccin.teal })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = catppuccin.base, fg = catppuccin.text })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = catppuccin.blue, bg = catppuccin.base })
vim.api.nvim_set_hl(0, "Pmenu", { bg = catppuccin.base, fg = catppuccin.text })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = catppuccin.surface1, fg = catppuccin.text })
vim.api.nvim_set_hl(0, "PmenuBorder", { fg = catppuccin.blue, bg = catppuccin.base })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = catppuccin.text })
vim.api.nvim_set_hl(0, "CmpItemKind", { fg = catppuccin.blue })
