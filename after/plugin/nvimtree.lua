vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  hijack_netrw = true,
  disable_netrw = true, -- Completely disable netrw
  view = {
    width = 35,
    side = "left",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    indent_markers = {
      enable = true,
    },
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
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
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
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
})

-- Keymaps for nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { silent = true, desc = "Find current file in explorer" })
vim.keymap.set("n", "<leader>ec", ":NvimTreeCollapse<CR>", { silent = true, desc = "Collapse file explorer" })

local function setup_catppuccin_nvimtree()
  local colors = require("catppuccin.palettes").get_palette()

  vim.api.nvim_set_hl(0,"Normal", {bg= "none"})

  local highlights = {
    NvimTreeNormal = { bg = colors.base },  -- Match editor background
    NvimTreeNormalNC = { bg = colors.base },
    NvimTreeEndOfBuffer = { bg = colors.base },
    NvimTreeVertSplit = { fg = colors.surface0, bg = colors.base },
    NvimTreeRootFolder = { fg = colors.mauve, bold = true },  -- Purple/mauve for root
    NvimTreeFolderName = { fg = colors.sapphire },  -- Blue for folders
    NvimTreeFolderIcon = { fg = colors.sapphire },
    NvimTreeEmptyFolderName = { fg = colors.sapphire },
    NvimTreeOpenedFolderName = { fg = colors.sky, bold = true },  -- Lighter blue when open
    NvimTreeSymlink = { fg = colors.teal },
    NvimTreeExecFile = { fg = colors.green },
    NvimTreeOpenedFile = { fg = colors.peach },  -- Orange for opened files
    NvimTreeModifiedFile = { fg = colors.yellow },
    NvimTreeSpecialFile = { fg = colors.flamingo },
    NvimTreeImageFile = { fg = colors.mauve },
    NvimTreeIndentMarker = { fg = colors.surface1 },
    -- Git colors
    NvimTreeGitDirty = { fg = colors.yellow },
    NvimTreeGitStaged = { fg = colors.green },
    NvimTreeGitMerge = { fg = colors.peach },
    NvimTreeGitRenamed = { fg = colors.mauve },
    NvimTreeGitNew = { fg = colors.green },
    NvimTreeGitDeleted = { fg = colors.red },
    NvimTreeGitIgnored = { fg = colors.overlay0 },
    -- File names match editor text color
    NvimTreeNormalText = { fg = colors.text },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Auto-command to setup colors after Catppuccin loads
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "catppuccin*",
  callback = setup_catppuccin_nvimtree,
})

-- If Catppuccin is already loaded, setup immediately
if vim.g.colors_name and vim.g.colors_name:match("catppuccin") then
  setup_catppuccin_nvimtree()
end
