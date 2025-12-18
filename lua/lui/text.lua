---@class Text
---@field startPoint Point
---@field private _content string

local Terminal = require("lui.terminal")

local term = Terminal.new()

local Text = {}
Text.__index = Text

---@param startPoint Point
---@param content string
function Text.new(startPoint, content)
	local self = {}

	self.startPoint = startPoint or { x = 0, y = 0 }
	self._content = content or ""

	setmetatable(self, Text)
	return self
end

---@param newPoint Point
function Text:updatePoint(newPoint)
	self._startPoint = newPoint
end

function Text:draw()
	term:drawAtPos(self._startPoint, self._content)
end

return Text
