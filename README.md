<div align="center">

[![GitHub Tag](https://img.shields.io/github/v/tag/neovim-idea/switcher-nvim?sort=semver&style=for-the-badge)](https://github.com/neovim-idea/switcher-nvim/releases)
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.10+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

## switcher-nvim

###### JetBrain's file switcher, for neovim :heart_eyes:

<table>
  <thead>
    <tr>
      <th align="center">DEFAULT (JetBrains)</th>
      <th align="center">CHEVRON</th>
      <th align="center">ICON MARGINS</th>
      <th align="center">MIXED</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="docs/default_60x35.gif" width="180" alt="default"/></td>
      <td><img src="docs/chevron_60x35.gif" width="180" alt="chevron"/></td>
      <td><img src="docs/icon_margins_60x35.gif" width="180" alt="icon margins"/></td>
      <td><img src="docs/mixed_60x35.gif" width="180" alt="mixed"/></td>
    </tr>
  </tbody>
</table>
</div>

<!-- TOC -->

* [Usage](#usage)
* [Installation](#installation)
  * [Lazy](#lazy)
  * [Packer](#packer)
  * [Plug](#plug)
* [Setup](#setup)
* [Styling](#styling)
* [Todo](#todo)
* [Buy me a :beer:](#buy-me-a-beer)

<!-- TOC -->

## Usage

Hit `<C-Tab>` to open the switcher; hit it some more to select the buffer you're interested into. If you don't do
anything for `500ms` (configurable, see below), the popup will close, and the selected buffer will be displayed.

`<C-Tab>` traverses buffers from the most recently opened, to the oldest; if you want to "go back" to a previous buffer
in the list, simply hit `<C-S-Tab>` as many times as you need.

Also, `<C-S-Tab>` does open the switcher, but it will start from the bottom of the list (aka the oldest buffer you've
opened).

## Installation

Requirements:

* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
* [nvim-web-dev-icons](https://github.com/nvim-tree/nvim-web-devicons)

### Lazy

> [!IMPORTANT]
> The plugin must NOT be lazy loaded!


```lua
{
  "neovim-idea/switcher-nvim",
  lazy = false,
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

`switcher-nvim` comes already with sensible configuration options; just remember to call
`require("switcher-nvim").setup()` and that's it, and you're good to go!

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
        opts = { noremap = true, desc = "Traverse Open Buffers from most recently accessed first" },
      },
      traverse_backwards = {
        mode = { "n", "i" },
        lhs = "<C-S-Tab>",
        opts = { noremap = true, desc = "Traverse Open Buffers from least recently accessed first" },
      },
      --[[Selection]]
      selection = {
        timeout_ms = 500,
        icon_margin_right = "", -- or "[", "<<<" ... any string, really :) 
        icon_margin_left  = "", -- or "]", ">>>" ...
        chevron = "", -- or "󰅂" , "󱞩", "-->" ...
      },
      --[[Borders]]
        borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }, -- or { "═", "║", "═", "║", "╔", "╗", "╝", "╚" }
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
- [x] protect main branch!
- [x] check if there are more than 2 buffers open, before opening the popup
- [x] start from the 2nd
- [x] walk the list in reverse order via `C-S-Tab`
  - [x] and start from the last element
- [ ] add a right side panel for the actions

## Buy me a :beer:

BTC `12CQ1L7qQvF3pPXhAgomnSfWaVkL19nV5F` 
