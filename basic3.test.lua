local flow = require 'flow'
local actual = {}

local arr = {
    function(down)
        table.insert(actual, 1)
        down()
        table.insert(actual, -1)
    end,
    function(down)
        table.insert(actual, 2)
        down()
        table.insert(actual, -2)
    end,
}

local expect = {1, 2, -2, -1}

local ok, msg = flow(arr)()
assert(ok)

assert(#expect == #actual)
for i = 1, #expect do
    assert(actual[i] == expect[i])
end

print('basic3 test ok!')
