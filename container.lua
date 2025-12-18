local Terminal = require("terminal")
local term = Terminal.new()

local Container = {}
Container.__index = Container

-- add a config to define what border chars to use
local BOX_HORIZONTAL = "─"
local BOX_VERTICAL = "│"
local BOX_CORNER_TOP_LEFT = "┌"
local BOX_CORNER_TOP_RIGHT = "┐"
local BOX_CORNER_BOTTOM_LEFT = "└"
local BOX_CORNER_BOTTOM_RIGHT = "┘"

---@enum Direction
local Direction = {
	Vertical = 1,
	Horizontal = 2,
}

function Container.new(startx, starty, endx, endy, name, body)
	local self = {}

	self._startx = startx or 0
	self._starty = starty or 0
	self._endx = endx or 0
	self._endy = endy or 0
	self._name = name or nil
	self._body = body or nil

	setmetatable(self, Container)
	return self
end

---@param startPoint Point
---@param endPoint Point
---@param direction Direction
function Container:_drawLine(startPoint, endPoint, direction)
	local character = direction == Direction.Vertical and BOX_VERTICAL or BOX_HORIZONTAL
	if direction == Direction.Vertical then
		local counter = startPoint.y
		while counter < endPoint.y do
			term:drawAtPos({ x = startPoint.x, y = counter }, character)
			counter = counter + 1
		end
	else
		local counter = startPoint.x
		while counter < endPoint.x do
			term:drawAtPos({ x = counter, y = startPoint.y }, character)
			counter = counter + 1
		end
	end
end

function Container:draw()
	-- top
	self:_drawLine({ x = self._startx, y = self._starty }, { x = self._endx, y = self._starty }, Direction.Horizontal)

	-- bottom
	self:_drawLine({ x = self._startx, y = self._endy }, { x = self._endx, y = self._endy }, Direction.Horizontal)

	-- left line
	self:_drawLine({ x = self._startx, y = self._starty }, { x = self._startx, y = self._endy }, Direction.Vertical)

	-- right
	self:_drawLine({ x = self._endx, y = self._starty }, { x = self._endx, y = self._endy }, Direction.Vertical)

	-- corners
	term:drawAtPos({ x = self._startx, y = self._starty }, BOX_CORNER_TOP_LEFT)
	term:drawAtPos({ x = self._endx, y = self._starty }, BOX_CORNER_TOP_RIGHT)
	term:drawAtPos({ x = self._startx, y = self._endy }, BOX_CORNER_BOTTOM_LEFT)
	term:drawAtPos({ x = self._endx, y = self._endy }, BOX_CORNER_BOTTOM_RIGHT)

	-- heading and body should be elements of the container and be recursively drawn
	term:drawAtPos({ x = self._startx + 1, y = self._starty + 1 }, self._name)

	-- render the body content
	-- needs wrapping logic to wrap when the line would outgrow the container
	-- endx - startx to get total cols of container
	-- at that many characters, increment y and reset x at previous space
end

return Container
