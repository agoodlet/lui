---@class Point
---@field x number
---@field y number

local Point = {}
Point.__index = Point

---@param x number
---@param y number
---@return Point
function Point.new(x, y)
	local self = {}

	self.x = x or 0
	self.y = y or 0

	setmetatable(self, Point)
	return self
end

return Point
