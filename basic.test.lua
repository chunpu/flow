local flow = require 'flow'
local actual = {}

local thread1 = coroutine.create(function(down)
    table.insert(actual, 'thread1-down')
    coroutine.yield(down)
    table.insert(actual, 'thread1-up')
end)

local thread2 = coroutine.create(function(down)
    table.insert(actual, 'thread2-down')
    coroutine.yield(down)
    table.insert(actual, 'thread2-up')
end)

local arr = {
    thread1,
    function(down)
        table.insert(actual, 1)
        down()
    end,
    thread2,
    function(down)
        table.insert(actual, 2)
        down()
    end,
}

local expect = {'thread1-down', 1, 'thread2-down', 2, 'thread2-up', 'thread1-up'}

flow(arr)()

assert(#expect == #actual)
for i = 1, #expect do
    assert(actual[i] == expect[i])
end

print('basic test ok!')
