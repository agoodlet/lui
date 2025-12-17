local Terminal = {}
Terminal.__index = Terminal

function Terminal.new()
  local self = {}

  local f = io.popen("stty size 2> /dev/tty")
  local output = f:read("*all")
  f:close()

  local rows, cols = output:match("(%d+)%s+(%d+)")
  self.rows = tonumber(rows) or 0
  self.cols = tonumber(cols) or 0
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

---@param point Point
function Terminal:setCursorPos(point)
  if point.x < self.cols and point.y < self.rows then
    io.write(string.format("\x1b[%d;%dH", point.y, point.x))
  else
    io.write("point is out of bounds")
  end
end

function Terminal:render()
  io.write("\x1bc")
  for _, v in pairs(self._elements) do
    v:draw()
  end

  -- the user should have the ability to decide if they would like to render the prompt or not
  local finish = string.format("\x1b[%d;1H", self.rows - 1)
  io.write(finish)
  io.flush()
end

return Terminal
