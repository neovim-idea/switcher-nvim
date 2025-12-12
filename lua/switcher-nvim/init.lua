local popup = require("switcher-nvim.popup")
local state = require("switcher-nvim.state")

local SwitcherNvim = {}

function SwitcherNvim.setup(opts)
  state.configure(opts or {})

  vim.keymap.set("n", state.keymap(), function()
    popup.open()
  end, { noremap = true })
end

function SwitcherNvim.open()
  popup.open()
end

function SwitcherNvim.close()
  popup.close()
end

return SwitcherNvim
