local flow = require 'flow'
local actual = {}

local hasyield = coroutine.create(function(down)
    table.insert(actual, 'has-yield-down')
    coroutine.yield(down)
    table.insert(actual, 'has-yield-up')
end)

local noyield = coroutine.create(function(down)
    table.insert(actual, 'no-yield-down')
end)

local arr = {
    hasyield,
    function(down)
        table.insert(actual, 1)
        down()
    end,
    noyield,
    function(down)
        table.insert(actual, 2)
        down()
    end,
}

local expect = {'has-yield-down', 1, 'no-yield-down', 'has-yield-up'}

flow(arr)()

assert(#actual == #expect)
for i = 1, #actual do
    assert(actual[i] == expect[i])
end

print('yield stop test ok!')
