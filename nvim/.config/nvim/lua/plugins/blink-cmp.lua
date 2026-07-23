--- Toggle Blink Completion using the keymap <leader>cq or <ctrl>+q
--- Try restarting NVIM (and not restoring previous session) if settings don't take effect
return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    local completion_toggle = Snacks.toggle({
      name = "Completion",
      get = function()
        return vim.b.completion
      end,
      set = function(state)
        vim.b.completion = state
      end,
    })

    local function toggle_completion()
      require("blink.cmp").hide()
      completion_toggle:toggle()
    end

    vim.keymap.set({ "n" }, "<leader>cq", toggle_completion, { desc = "Toggle Blink Completion" })
    vim.keymap.set({ "i", "n" }, "<C-q>", toggle_completion, { desc = "Toggle Blink Completion" })
    opts.enabled = function()
      return vim.b.completion
    end

    return opts
  end,
}
