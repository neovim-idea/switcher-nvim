local devicons = require("nvim-web-devicons")

local Icons = {}

local cache = {}
local fallback_icon = "?"

function Icons.get_icon(filename)
  if cache[filename] then
    return cache[filename].icon, cache[filename].hl
  end

  local extension = filename:match("^.+%.([^%.]+)$")
  local icon, highlight = devicons.get_icon(filename, extension, { default = false })

  cache[filename] = { icon = icon or fallback_icon, hl = highlight }
  return cache[filename].icon, cache[filename].hl
end

return Icons
