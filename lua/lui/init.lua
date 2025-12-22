---@class lui
---@field terminal Terminal
---@field container Container
---@field point Point
---@field text Text
local M = {}

-- Require the sub-modules
-- Note: we use the full path starting from 'lua/'
M.terminal = require("lui.terminal")
M.container = require("lui.container")
M.point = require("lui.point")
M.text = require("lui.text")

---@param name string
function M.setup(name)
	print("LUI Initialized: " .. name)
end

return M
