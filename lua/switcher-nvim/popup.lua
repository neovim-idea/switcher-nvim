local popup_lib = require("plenary.popup")
local state = require("switcher-nvim.state")

local Popup = {}

local border = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
local highlight_prefix = "NeovimIdeaSwitcher"

local function close()
  local win = state.window()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end

  state.set_window(nil)
  state.set_buffer(nil)
  state.stop_close_timer()

  local cb = state.user_callback()
  local sel = state.selected()
  if cb and sel then
    cb(sel)
    state.reset_selection()
    state.set_selected(nil)
  end
end

local function select_next()
  local win = state.window()
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return
  end

  local idx = state.increment_index()
  vim.api.nvim_win_set_cursor(win, { idx, 0 })
end

local function open()
  state.update_items()
  local items = state.items()

  local win = state.window()
  if win and vim.api.nvim_win_is_valid(win) then
    select_next()
    state.start_close_timer(close)
    return
  end

  local height = math.max(#items, 1)
  local width = 30


  local rows = vim.tbl_map(function(item) return item.text end, items)
  local popup_win = popup_lib.create(rows, {
    highlight = highlight_prefix,
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = border,
    enter = false,
    focusable = false,
  })

  state.set_window(popup_win)
  local buf = vim.api.nvim_win_get_buf(popup_win)
  state.set_buffer(buf)

  for i, item in ipairs(items) do
    if item.icon_hl then
      -- highlight only the icon
      -- icon starts at column 2: "  <icon>  filename"
      local icon_start_col = 2
      local icon_end_col = icon_start_col + item.icon_len

      vim.api.nvim_buf_add_highlight(
        buf,
        -1,
        item.icon_hl, -- from nvim-web-devicons
        i - 1, -- line index (0-based)
        icon_start_col, -- start col
        icon_end_col -- end col (exclusive)
      )
    end
  end

  vim.api.nvim_win_set_option(popup_win, "wrap", false)
  vim.api.nvim_win_set_option(popup_win, "list", false)
  vim.api.nvim_win_set_option(popup_win, "number", false)
  vim.api.nvim_win_set_option(popup_win, "relativenumber", false)

  local winhighlight = "Cursor:"
    .. highlight_prefix
    .. "Cursor,"
    .. "CursorLine:"
    .. highlight_prefix
    .. "CursorLine,"
    .. "CursorLineNC:"
    .. highlight_prefix
    .. "CursorLineNC"

  -- stolen from neotree
  if vim.version().minor >= 7 then
    vim.api.nvim_win_set_option(
      popup_win,
      "winhighlight",
      winhighlight .. ",WinSeparator:" .. highlight_prefix .. "Separator"
    )
  else
    vim.api.nvim_win_set_option(popup_win, "winhighlight", winhighlight)
  end

  vim.wo[popup_win].cursorline = true
  vim.api.nvim_win_set_cursor(popup_win, { state.current_index(), 0 })

  state.reset_selection()
  state.start_close_timer(close)
end

Popup.open = open
Popup.close = close

return Popup
