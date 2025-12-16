local Terminal = {}
Terminal.__index = Terminal

local BOX_HORIZONTAL = "─"
local BOX_VERTICAL = "│"
local BOX_CORNER_TOP_LEFT = "┌"
local BOX_CORNER_TOP_RIGHT = "┐"
local BOX_CORNER_BOTTOM_LEFT = "└"
local BOX_CORNER_BOTTOM_RIGHT = "┘"

function Terminal:new()
  local self = {}

  local f = io.popen("stty size 2> /dev/tty")
  local output = f:read("*all")
  f:close()

  local rows, cols = output:match("(%d+)%s+(%d+)")
  self.rows = rows
  self.cols = cols
  self._elements = {}

  setmetatable(self, Terminal)
  return self
end

function Terminal:addElement(el)
  table.insert(self._elements, el)
end

function Terminal:getElements()
  return self._elements
end

function Terminal:render()
  local bottomRow = 0
  -- iterate through elements and render them
  -- maybe pass the logic for rendering back to the element
  -- container has a render method on it that we call from term:render
  io.write("\x1bc")
  for _, v in pairs(self._elements) do
    local top = v.startx
    while top < v.endx do
      local position = string.format("\x1b[%d;%dH", v.starty, top)
      io.write(position, BOX_HORIZONTAL)
      top = top + 1
    end

    local bottom = v.startx
    while bottom <= v.endx do
      local position = string.format("\x1b[%d;%dH", v.endy, bottom)
      io.write(position, BOX_HORIZONTAL)
      bottom = bottom + 1
    end

    local right = v.starty
    while right < v.endy do
      local position = string.format("\x1b[%d;%dH", right, v.endx)
      io.write(position, BOX_VERTICAL)
      right = right + 1
    end

    local left = v.starty
    while left < v.endy do
      local position = string.format("\x1b[%d;%dH", left, v.startx)
      io.write(position, BOX_VERTICAL)
      left = left + 1
    end

    -- corners
    local topLeft = string.format("\x1b[%d;%dH", v.starty, v.startx)
    io.write(topLeft, BOX_CORNER_TOP_LEFT)
    local topRight = string.format("\x1b[%d;%dH", v.starty, v.endx)
    io.write(topRight, BOX_CORNER_TOP_RIGHT)
    local bottomLeft = string.format("\x1b[%d;%dH", v.endy, v.startx)
    io.write(bottomLeft, BOX_CORNER_BOTTOM_LEFT)
    local bottomRight = string.format("\x1b[%d;%dH", v.endy, v.endx)
    io.write(bottomRight, BOX_CORNER_BOTTOM_RIGHT)

    local headingPos = string.format("\x1b[%d;%dH", v.startx + 1, v.starty + 1)
    io.write(headingPos, v.name)

    if v.endy > bottomRow then
      bottomRow = v.endy
    end
  end

  local finish = string.format("\x1b[%d;1H", self.rows - 1)
  io.write(finish)
  io.flush()
end

return Terminal
