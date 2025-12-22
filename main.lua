package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

local lui = require("lui")

local term = lui.terminal.new()

-- OVERLAP
-- box:addElement(body)
-- term:addElement(box)

-- local box2 = lui.container.new({ x = 12, y = 17 }, { x = 75, y = 20 })
-- local heading2 = lui.text.new({ x = 1, y = 1 }, "Container")
-- box2:addElement(heading2)
-- term:addElement(box2)

-- SIDE BY SIDE
local box1 = lui.container.new({ x = 1, y = 1 }, { x = (term.cols / 2) - 1, y = term.rows - 2 })
local heading1 = lui.text.new({ x = 1, y = 1 }, "test")
local body1 = lui.text.new({ x = 1, y = 3 }, "this is the body for the first box")
box1:addElement(heading1)
box1:addElement(body1)
term:addElement(box1)

local box2 = lui.container.new({ x = term.cols / 2, y = 1 }, { x = term.cols - 1, y = term.rows - 2 })
local heading2 = lui.text.new({ x = 1, y = 1 }, "test2")
local body2 = lui.text.new({ x = 1, y = 3 }, "this is the body for the second box")
box2:addElement(heading2)
box2:addElement(body2)
term:addElement(box2)

-- term:handleEvents
while true do
  -- have to diff the last state to know what to re-draw
  term:render()
end
