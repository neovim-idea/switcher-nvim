local Utils = {}

function Utils.available_buffers()
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

  return filtered
end

return Utils

