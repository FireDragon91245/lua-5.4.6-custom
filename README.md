# This is a modified version of the lua Interpreter
Original Version Lua 5.4.6 from [here](https://www.lua.org/)
[Download Page](https://www.lua.org/download.html)
[Direct Download](https://www.lua.org/ftp/lua-5.4.6.tar.gz)

## Modifications
- Added '__override' metamethod that is called when a existing key in a table is asigned a new value
- -> If __override exists gets called and the default asignment is cancled

Example:
```lua
local t = {}
setmetatable(t, {
    __override = function(table, key, new_value, old_value)
        print("override", key, new_value, old_value)
    end
})

t.a = 1
print("a value", t.a)
t.a = 2 -- __override gets called default asignment is cancled
print("a value", t.a)

-- stdout:
-- a value 1
-- override a 2 1
-- a value 1
```

# Original README
This is Lua 5.4.6, released on 02 May 2023.

For installation instructions, license details, and
further information about Lua, see doc/readme.html.

