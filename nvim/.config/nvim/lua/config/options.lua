-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- don't show hidden characters
opt.list = false

-- enable relative line numbers
opt.rnu = true

-- enable wrapping lines
opt.wrap = true

-- stop explorer launching on start
vim.g.snacks_explorer = {
  replace_netrw = false,
}
