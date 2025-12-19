## switcher-nvim

A simple, yet powerful switcher, similar to JetBrain's one.

![Simple example of switcher-nvim usage](docs/usage.gif "Sample usage")

Requirements:

* plenary
* nvim-web-dev-icons


## Installation

### Lazy
```lua
{
  "neovim-idea/switcher-nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons"
  },
}
```

### Packer
```lua
use {
  "neovim-idea/switcher-nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons"
    }
}
```

### Plug
```lua
Plug "nvim-lua/plenary.nvim"
Plug "nvim-tree/nvim-web-devicons"
Plug "neovim-idea/switcher-nvim"
```

## Setup

`switcher-nvim` comes already with sensible configuration options; just remember to `require("switcher-nvim").setup()`
and you're good to go!

However, in case you'd like to change shortcuts or indicator appearances, you can tweak the options here below:

```lua
return {
  "neovim-idea/switcher-nvim",
  config = function()
    require("switcher-nvim").setup({
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
      --[[Indicators]]
      indicators = {
        timeout_ms = 500,
        icon_margin_left  = "",
        icon_margin_right = "",
        chevron = "󰅂",
      },
      --[[Layout]]
  })
  end,
}
```

## Styling

Should you desire to change the colors of the popup and buffer lines, you can do so by applying customized highlights to
the following highlight groups

```lua
NeovimIdeaSwitcherCursor
NeovimIdeaSwitcherCursorLine
NeovimIdeaSwitcherCursorLineNC
NeovimIdeaSwitcherNormal
NeovimIdeaSwitcherNormalNC
NeovimIdeaSwitcherFloatBorder
```

## Todo

- [ ] add tests!
- [x] start from the 2nd
- [x] walk the list in reverse order via `C-S-Tab`
  - [x] and start from the 2nd to last element (no nee)
- [ ] add a right side panel for the actions 
