local flow = require 'flow'
local actual = {}

local thread1 = coroutine.create(function(down, x, y)
    table.insert(actual, 'thread1-down' .. x .. y)
    coroutine.yield(down)
    table.insert(actual, 'thread1-up' .. x .. y)
end)

local thread2 = coroutine.create(function(down, x, y)
    table.insert(actual, 'thread2-down' .. x .. y)
    coroutine.yield(down)
    table.insert(actual, 'thread2-up' .. x .. y)
end)

local arr = {
    thread1,
    function(down, x, y)
        table.insert(actual, 1 .. x .. y)
        down()
    end,
    thread2,
    function(down, x, y)
        table.insert(actual, 2 .. x .. y)
        down()
    end,
}

local expect = {'thread1-down111222', '1111222', 'thread2-down111222', '2111222', 'thread2-up111222', 'thread1-up111222'}

flow(arr, 111, 222)()

assert(#expect == #actual)
for i = 1, #expect do
    assert(actual[i] == expect[i])
end

print('args test ok!')
