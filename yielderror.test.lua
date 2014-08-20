local flow = require 'flow'
local actual = {}

local thread1 = coroutine.create(function(down)
    table.insert(actual, 'thread1-down')
    coroutine.yield(down)
    assert(false, 'customerror')
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

local expect = {'thread1-down', 1, 'thread2-down', 2, 'thread2-up'}

local ok, msg = flow(arr)()
assert(ok == false)
assert(type(msg) == 'string')
assert(msg:find('customerror'))
assert(#expect == #actual)
for i = 1, #actual do
    assert(actual[i] == expect[i])
end

print('yield error catch test ok!')
