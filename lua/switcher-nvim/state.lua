local State = {}

local uv = vim.loop
local icons = require("switcher-nvim.icons")

-- internal state
local popup_win = nil
local popup_buf = nil
local items = {}
local buf_map = {}
local current_index = nil
local keymap = "<C-Tab>"
local timeout_ms = 500
local user_callback = function(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end
local close_timer = nil
local selected_bufnr = nil

function State.configure(opts)
  keymap = opts.keymap or keymap
  timeout_ms = opts.timeout_ms or timeout_ms
  -- TODO perhaps let the user choose ot turn it off and use arrows & CR instead of the logic with timers
  user_callback = opts.user_callback or user_callback
end

function State.reset_selection()
  current_index = nil
  selected_bufnr = buf_map[current_index]
end

function State.keymap()
  return keymap
end

function State.timeout()
  return timeout_ms
end

function State.window()
  return popup_win
end

function State.buffer()
  return popup_buf
end

function State.set_window(win)
  popup_win = win
end

function State.set_buffer(buf)
  popup_buf = buf
end

function State.set_selected(bufnr)
  selected_bufnr = bufnr
end

function State.selected()
  return buf_map[current_index]
end

function State.user_callback()
  return user_callback
end

function State.close_timer()
  return close_timer
end

function State.start_close_timer(cb)
  if close_timer then
    close_timer:stop()
    close_timer:close()
  end
  close_timer = uv.new_timer()
  close_timer:start(timeout_ms, 0, vim.schedule_wrap(cb))
end

function State.stop_close_timer()
  if close_timer then
    close_timer:stop()
    close_timer:close()
    close_timer = nil
  end
end

function State.items()
  return items
end

function State.buf_map()
  return buf_map
end

-- Refresh items based on last-used buffers
function State.update_items()
  items = {}
  buf_map = {}

  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local filtered = {}

  for _, b in ipairs(bufs) do
    if b.loaded and vim.api.nvim_buf_get_option(b.bufnr, "modifiable") then
      table.insert(filtered, b)
    end
  end

  table.sort(filtered, function(a, b)
    return (a.lastused or 0) > (b.lastused or 0)
  end)

  for i, b in ipairs(filtered) do
    local name = vim.api.nvim_buf_get_name(b.bufnr)
    local filename = vim.fn.fnamemodify(name, ":t")
    if filename ~= "" then
      local icon, icon_hl = icons.get_icon(filename)
      buf_map[i] = b.bufnr
      items[i] = {
        text = "  " .. icon .. "  " .. filename,
        icon_len = vim.fn.strchars(icon),
        icon_hl = icon_hl,
      }
    end
  end
end

function State.increment_index(step_increment)
  local count = #items
  if current_index == nil then
    if step_increment == -1 then
      current_index = count - 1
    else
      current_index = 2
    end
    return current_index
  end

  current_index = current_index + step_increment
  if current_index > count then
    current_index = 2
  end
  if current_index < 1 then
    current_index = count - 1
  end
  selected_bufnr = buf_map[current_index]
  return current_index
end

function State.current_index(step_increment)
  local count = #items
  if current_index == nil then
    if step_increment == -1 then
      current_index = count - 1
    else
      current_index = 2
    end
    return current_index
  end
  selected_bufnr = buf_map[current_index]
  return current_index
end

return State
