local SwitcherNvim = {}

local popup = require("switcher-nvim.popup")
local state = require("switcher-nvim.state")

local defaults = {
  --[[General]]
  traverse_forwards = {
    mode = { "n", "i" },
    lhs = "<C-Tab>",
    rhs = popup.step_forwards,
    opts = { noremap = true, desc = "Traverse Open Buffers from most recently accessed first" },
  },
  traverse_backwards = {
    mode = { "n", "i" },
    lhs = "<C-S-Tab>",
    rhs = popup.step_backwards,
    opts = { noremap = true, desc = "Traverse Open Buffers from least recently accessed first" },
  },
  --[[Layout]]
}

function SwitcherNvim.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})
  local tf = config.traverse_forwards
  local tb = config.traverse_backwards

  state.configure(config)
  vim.keymap.set(tf.mode, tf.lhs, tf.rhs, tf.opts)
  vim.keymap.set(tb.mode, tb.lhs, tb.rhs, tb.opts)
end

return SwitcherNvim
