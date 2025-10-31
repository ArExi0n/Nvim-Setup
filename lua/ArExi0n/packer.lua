-- lua/ArExi0n/packer.lua
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            vim.cmd('colorscheme catppuccin-frappe')
        end
    })

    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use('nvim-treesitter/playground')
    use('tpope/vim-fugitive')
    use "mbbill/undotree"
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'VonHeikemen/lsp-zero.nvim'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'theprimeagen/harpoon'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    use({
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<C-Right>",
                        accept_line = "<C-l>",
                        next = "<C-]>",
                        prev = "<C-[>",
                        dismiss = "<C-e>",
                    },
                },
                panel = { enabled = false },
            })
        end,
    })

    use({
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    })

    use({
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        requires = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }

            require("CopilotChat").setup({
                debug = false,
                window = {
                    layout = "float",
                    relative = "editor",
                    width = 0.45,
                    height = 0.6,
                    border = "rounded",
                },
            })

            map("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", opts)
            map("n", "<leader>cx", "<cmd>CopilotChatReset<CR>", opts)
            map("n", "gr", "<cmd>CopilotChatRefresh<CR>", opts)
            map("n", "<M-CR>", "<cmd>CopilotChatToggle<CR>", opts)
            map("n", "<leader>ce", "<cmd>CopilotChatExplain<CR>", opts)
            map("n", "<leader>cf", "<cmd>CopilotChatFix<CR>", opts)
            map("n", "<leader>cF", "<cmd>CopilotChatDiagnostics<CR>", opts)
            map("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", opts)
            map("v", "<leader>co", "<cmd>CopilotChatOptimize<CR>", opts)
            map("v", "<leader>cr", "<cmd>CopilotChatReview<CR>", opts)
            map("n", "<leader>cq", "<cmd>CopilotChatQuick<CR>", opts)
            map("n", "<leader>cd", "<cmd>CopilotChatDocs<CR>", opts)
            map("n", "<leader>ct", "<cmd>CopilotChatTests<CR>", opts)
            map("n", "[[", "<cmd>CopilotChatPrev<CR>", opts)
            map("n", "]]", "<cmd>CopilotChatNext<CR>", opts)
        end,
    })
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.smartindent = true
end)
