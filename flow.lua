-- koa style downstream and upstream

function flow(arr, ...)
    local args = {...}
    local i = 0
    local len = #arr
    return function()
        function down(ok)
            if len <= i then return end
            i = i + 1
            local x = arr[i]
            local tp = type(x)
            if tp == 'function' then
                x(down, unpack(args))
            elseif tp == 'thread' then
                local chain, ret = coroutine.resume(x, down, unpack(args))
                if chain and ret == down then
                    down()
                    coroutine.resume(x, down, unpack(args))
                end
            end
        end
        down()
    end
end

return flow
