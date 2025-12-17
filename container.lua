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

function Container:draw()
  -- can I abstract this to a separate func call
  local top = self._startx
  while top < self._endx do
    local position = string.format("\x1b[%d;%dH", self._starty, top)
    io.write(position, BOX_HORIZONTAL)
    top = top + 1
  end

  local bottom = self._startx
  while bottom <= self._endx do
    local position = string.format("\x1b[%d;%dH", self._endy, bottom)
    io.write(position, BOX_HORIZONTAL)
    bottom = bottom + 1
  end

  local right = self._starty
  while right < self._endy do
    local position = string.format("\x1b[%d;%dH", right, self._endx)
    io.write(position, BOX_VERTICAL)
    right = right + 1
  end

  local left = self._starty
  while left < self._endy do
    local position = string.format("\x1b[%d;%dH", left, self._startx)
    io.write(position, BOX_VERTICAL)
    left = left + 1
  end

  -- corners
  -- old way
  local topLeft = string.format("\x1b[%d;%dH", self._starty, self._startx)
  io.write(topLeft, BOX_CORNER_TOP_LEFT)

  -- new way
  term:setCursorPos({ x = self._starty, y = self._startx })
  io.write(BOX_CORNER_TOP_LEFT)

  local topRight = string.format("\x1b[%d;%dH", self._starty, self._endx)
  io.write(topRight, BOX_CORNER_TOP_RIGHT)
  local bottomLeft = string.format("\x1b[%d;%dH", self._endy, self._startx)
  io.write(bottomLeft, BOX_CORNER_BOTTOM_LEFT)
  local bottomRight = string.format("\x1b[%d;%dH", self._endy, self._endx)
  io.write(bottomRight, BOX_CORNER_BOTTOM_RIGHT)

  local headingPos = string.format("\x1b[%d;%dH", self._startx + 1, self._starty + 1)
  io.write(headingPos, self._name)

  -- render the body content
  -- needs wrapping logic to wrap when the line would outgrow the container
  -- endx - startx to get total cols of container
  -- at that many characters, increment y and reset x at previous space
end

return Container
