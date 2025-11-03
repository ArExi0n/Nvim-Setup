vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  hijack_netrw = true,
  disable_netrw = true,
  view = {
    width = 35,
    side = "left",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          renamed = "➜",
          untracked = "★",
          ignored = "◌",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$", "node_modules", ".cache" },
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = { quit_on_open = false, resize_window = true },
  },
  update_focused_file = { enable = true, update_root = false },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find current file" })
vim.keymap.set("n", "<leader>ec", ":NvimTreeCollapse<CR>", { silent = true, desc = "Collapse file explorer" })

-- Transparent + Catppuccin integration
local function setup_catppuccin_nvimtree()
  local colors = require("catppuccin.palettes").get_palette("frappe")

  local highlights = {
    -- 🔹 Make background transparent
    NvimTreeNormal = { bg = "none" },
    NvimTreeNormalNC = { bg = "none" },
    NvimTreeEndOfBuffer = { bg = "none" },
    NvimTreeVertSplit = { fg = colors.surface0, bg = "none" },

    -- 🔹 Text + icons
    NvimTreeRootFolder = { fg = colors.mauve, bold = true },
    NvimTreeFolderName = { fg = colors.sapphire },
    NvimTreeFolderIcon = { fg = colors.sapphire },
    NvimTreeOpenedFolderName = { fg = colors.sky, bold = true },
    NvimTreeSymlink = { fg = colors.teal },
    NvimTreeExecFile = { fg = colors.green },
    NvimTreeOpenedFile = { fg = colors.peach },
    NvimTreeModifiedFile = { fg = colors.yellow },
    NvimTreeSpecialFile = { fg = colors.flamingo },
    NvimTreeIndentMarker = { fg = colors.surface1 },

    -- 🔹 Git status
    NvimTreeGitDirty = { fg = colors.yellow },
    NvimTreeGitStaged = { fg = colors.green },
    NvimTreeGitMerge = { fg = colors.peach },
    NvimTreeGitRenamed = { fg = colors.mauve },
    NvimTreeGitNew = { fg = colors.green },
    NvimTreeGitDeleted = { fg = colors.red },
    NvimTreeGitIgnored = { fg = colors.overlay0 },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Apply after Catppuccin loads
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "catppuccin*",
  callback = setup_catppuccin_nvimtree,
})

-- In case Catppuccin is already active
if vim.g.colors_name and vim.g.colors_name:match("catppuccin") then
  setup_catppuccin_nvimtree()
end

