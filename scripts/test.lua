local table = {}
setmetatable(table, {__newindex = function (t, k, v)
	print("newindex", k, v)
	rawset(t, k, v)
end, __override = function (t, k, new_val, old_val)
	print("override", k, new_val, old_val)
	rawset(t, k, new_val)
end
})
table.abc = 1
print(table.abc)
table.abc = 2
print(table.abc)
table[1] = 10
table[1] = 20
rawset(table, 1, 30)

table.c = nil
table.c = 1
table.c = 1