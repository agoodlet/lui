---@class Container
---@field private _startx number
---@field private _starty number
---@field private _endx number
---@field private _endy number
---@field private _elements table # A list of elements contained within this container
---@field new fun(startPoint: Point, endPoint: Point)
---@field addElement fun(self, element)

local Terminal = require("lui.terminal")
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

---@param startPoint Point
---@param endPoint Point
function Container.new(startPoint, endPoint)
	local self = {}

	self._startx = startPoint.x or 0
	self._starty = startPoint.y or 0
	self._endx = endPoint.x or 0
	self._endy = endPoint.y or 0
	self._elements = {}

	setmetatable(self, Container)
	return self
end

-- TODO define an element interface
function Container:addElement(element)
	-- rewrite the Point of the element to be relative to the Container
	-- if the new point is outside the bounds of the container, what do?
	print(self._startx)
	element:updatePoint({ x = self._startx + element.startPoint.x, y = self._starty + element.startPoint.y })
	table.insert(self._elements, element)
end

---@param startPoint Point
---@param endPoint Point
---@param direction Direction
function Container:_drawLine(startPoint, endPoint, direction)
	local character = direction == Direction.Vertical and BOX_VERTICAL or BOX_HORIZONTAL
	-- I feel like there's a way to get rid of the if here
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

	-- recursively render elements of container
	for _, v in pairs(self._elements) do
		v:draw()
	end
end

return Container
