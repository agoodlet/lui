local Terminal = require("terminal")
local Container = require("container")

local term = Terminal.new()

local box = Container.new(1, 1, term.cols - 1, term.rows - 2, "test")
term:addElement(box)
local box2 = Container.new(12, 17, 75, 20, "Container")
term:addElement(box2)

term:render()
