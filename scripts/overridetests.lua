local mt = {
    __override = function(t, k, oldval, newval)
        print("Direct assignment __override: key = " .. tostring(k))
    end
}

local test_table = setmetatable({}, mt)
test_table.a = 1  -- First assignment, no __override
test_table.a = 2  -- Second assignment, should trigger __override

local function createClosure()
    local upval_table = setmetatable({}, {
        __override = function(t, k, oldval, newval)
            print("Upvalue assignment __override: key = " .. tostring(k))
        end
    })

    return function()
        print("hey")
        upval_table.a = 10  -- First assignment, no __override
        upval_table.a = 20  -- Second assignment, should trigger __override
    end
end

local closure = createClosure()
closure()

mt = {
    __override = function(t, k, oldval, newval)
        print("Integer key assignment __override: key = " .. tostring(k))
    end
}

test_table = setmetatable({}, mt)
test_table[1] = 1   -- First assignment, no __override
test_table[1] = 2   -- Second assignment, should trigger __override
