return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      go = { "goimports", "golines" },
    },
    formatters = {
      golines = {
        args = { "-m", "160", "--base-formatter", "gofumpt" },
      },
    },
    -- format_on_save = {
    --   -- lsp_fallback = true,
    --   async = true,
    --   timeout_ms = 2000,
    -- },
  },
}
