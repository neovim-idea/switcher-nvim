local devicons = require("nvim-web-devicons")

local Icons = {}

local cache = {}
local fallback_icon = "?"

function Icons.get_icon(filename)
  if cache[filename] then
    return cache[filename]
  end

  local extension = filename:match("^.+%.([^%.]+)$")
  local icon = devicons.get_icon(filename, extension, { default = false }) or fallback_icon

  cache[filename] = icon
  return icon
end

return Icons
