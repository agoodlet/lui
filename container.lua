local Container = {}
Container.__index = Container

function Container:new(startx, starty, endx, endy, name)
  self = {}

  self.startx = startx or 0
  self.starty = starty or 0
  self.endx = endx or 0
  self.endy = endy or 0
  self.name = name or "Container"

  setmetatable(self, Container)
  return self
end

return Container
