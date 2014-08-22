-- koa style downstream and upstream

return function (arr, ...)
    local args = {...}
    local i = 0
    local len = #arr
    local safe = function()
        function down(ok)
            if len <= i then return end
            i = i + 1
            local x = arr[i]
            local tp = type(x)
            if tp == 'function' then
                x(down, unpack(args))
            elseif tp == 'thread' then
                local ok, ret = coroutine.resume(x, down, unpack(args))
                assert(ok, ret)
                if ret == down then
                    down()
                    local ok, msg = coroutine.resume(x, down, unpack(args))
                    assert(ok, msg)
                end
            end
        end
        down()
    end
    return function()
        return xpcall(safe, function(err)
            return debug.traceback(err, 2)
        end)
    end
end
