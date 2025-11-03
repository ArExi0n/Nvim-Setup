return require("packer").startup(function(use)
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        transparent_background = true,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = { enabled = true },
          mason = true,
          notify = true,
          mini = true,
          neotree = true,
          which_key = true,
          native_lsp = {
            enabled = true,
            virtual_text = { errors = {}, hints = {}, warnings = {}, information = {} },
            underlines = { errors = {}, hints = {}, warnings = {}, information = {} },
            inlay_hints = { background = false },
          },
        },
      })

      -- Set the theme
      vim.cmd.colorscheme("catppuccin-frappe")

      -- Make all major UI parts transparent
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
    end,
  })
end)

