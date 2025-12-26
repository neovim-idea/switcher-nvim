local SwitcherNvim = {}

local popup = require("switcher-nvim.popup")
local state = require("switcher-nvim.state")

local defaults = {
  --[[General]]
  traverse_forwards = {
    mode = { "n", "i" },
    keymap = "<C-Tab>",
    opts = { noremap = true, desc = "Traverse Open Buffers from most recently accessed first" },
  },
  traverse_backwards = {
    mode = { "n", "i" },
    keymap = "<C-S-Tab>",
    opts = { noremap = true, desc = "Traverse Open Buffers from least recently accessed first" },
  },
  --[[Selection]]
  selection = {
    timeout_ms = 500,
    icon_margin_right = "",
    icon_margin_left = "",
    chevron = "",
  },
  --[[Borders]]
  borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}

function SwitcherNvim.setup(opts)
  local config = vim.tbl_deep_extend("force", defaults, opts or {})
  local tf = config.traverse_forwards
  local tb = config.traverse_backwards

  popup.setup(config.borders)
  state.setup(config.selection)
  vim.keymap.set(tf.mode, tf.keymap, popup.step_forwards, tf.opts)
  vim.keymap.set(tb.mode, tb.keymap, popup.step_backwards, tb.opts)
end

return SwitcherNvim
