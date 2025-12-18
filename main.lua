package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

local lui = require("lui")

local term = lui.terminal.new()

-- pass in a table of config instead of taking in everything as an arg
-- this would allow we to easily define children elements
local box = lui.container.new({ x = 1, y = 1 }, { x = term.cols - 1, y = term.rows - 2 })
local heading = lui.text.new({ x = 1, y = 1 }, "test")
local body = lui.text.new({ x = 1, y = 3 }, "This is the body of the container")
box:addElement(heading)
box:addElement(body)
term:addElement(box)

local box2 = lui.container.new({ x = 12, y = 17 }, { x = 75, y = 20 })
local heading2 = lui.text.new({ x = 1, y = 1 }, "Container")
box2:addElement(heading2)
term:addElement(box2)

term:render()
