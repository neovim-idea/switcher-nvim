local Popup = {}

local popup_lib = require("plenary.popup")
local state = require("switcher-nvim.state")

local border = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
local highlight_prefix = "NeovimIdeaSwitcher"
local ns = vim.api.nvim_create_namespace("my_prompt_ns")

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
  end
end

local function update_active_state(index)
  local buf = state.buffer()
  local line_count = vim.api.nvim_buf_line_count(buf)

  -- Clear previous highlights in this namespace
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for lnum = 0, line_count - 1 do
    local hl = "NeovimIdeaSwitcherInactiveSelection"
    if lnum == index - 1 then
      hl = "NeovimIdeaSwitcherActiveSelection"
    end
    -- Highlight the chevron symbol
    vim.api.nvim_buf_add_highlight(buf, ns, hl, lnum, 0, vim.fn.strdisplaywidth(state.chevron()))
  end
end

local function select_next(step_increment)
  local win = state.window()
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return
  end

  local next_index = state.increment_index(step_increment)
  update_active_state(next_index)
  vim.api.nvim_win_set_cursor(win, { next_index, 0 })
end

local function open_or_step(step_increment)
  state.update_items()
  local items = state.items()

  local win = state.window()
  if win and vim.api.nvim_win_is_valid(win) then
    select_next(step_increment)
    state.start_close_timer(close)
    return
  end

  local height = math.max(#items, 1)
  local width = 30

  local rows = vim.tbl_map(function(item)
    return item.text
  end, items)

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
      -- icon starts at column "<chevron_len>  <icon>  filename"
      local icon_start_col = #state.chevron()
      local icon_end_col = icon_start_col + item.icon_len

      vim.api.nvim_buf_add_highlight(buf, -1, item.icon_hl, i - 1, icon_start_col, icon_end_col)
    end
  end

  vim.api.nvim_win_set_option(popup_win, "wrap", false)
  vim.api.nvim_win_set_option(popup_win, "list", false)
  vim.api.nvim_win_set_option(popup_win, "number", false)
  vim.api.nvim_win_set_option(popup_win, "relativenumber", false)
  vim.api.nvim_win_set_option(popup_win, "cursorline", true)

  local winhighlight = "Cursor:"
    .. highlight_prefix
    .. "Cursor,"
    .. "CursorLine:"
    .. highlight_prefix
    .. "CursorLine,"
    .. "CursorLineNC:"
    .. highlight_prefix
    .. "CursorLineNC,"
    .. "NormalNC:"
    .. highlight_prefix
    .. "NormalNC"

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

  -- Define highlights
  local hl = vim.api.nvim_get_hl(0, { name = "NeovimIdeaSwitcherNormalNC" })
  vim.api.nvim_set_hl(0, "NeovimIdeaSwitcherInactiveSelection", { fg = hl.bg })
  vim.api.nvim_set_hl(0, "NeovimIdeaSwitcherActiveSelection", { fg = hl.fg })

  state.reset_selection()
  local index = state.current_index(step_increment)
  update_active_state(index)
  vim.api.nvim_win_set_cursor(popup_win, { index, 0 })

  state.start_close_timer(close)
end

function Popup.step_forwards()
  open_or_step(1)
end

function Popup.step_backwards()
  open_or_step(-1)
end

Popup.close = close

return Popup
