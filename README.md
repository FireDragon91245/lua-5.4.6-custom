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

## Why?
**🤓 am actualy you can use proxy tables**  
yes youre correct you can recreate __override with proxytables
```lua
local table = {}
local backing_table = {}
local proxy = {
    __index = function (t, k)
        return backing_table[k]
    end,
    __newindex = function (t, k, v)
        if backing_table[k] then
            print("override", k, v, backing_table[k])
        else
            backing_table[k] = v
        end
    end
}

setmetatable(table, proxy)


table.a = 1
print("a value", table.a)
table.a = 2
print("a value", table.a)
```

exact same output as __override

### BUT
try creating a proxyed proxy table on a table  
this simple example:
```lua
local table = {}
local backing_table = {}

local proxy = {}
local backing_proxy = {
    __newindex = function(self, key, value)
        print("newindex in table")
        backing_table[key] = value
    end,
    __index = function(self, key)
        print("index in table")
        return backing_table[key]
    end
}

local proxy_proxy = {
    __newindex = function(self, key, value)
        print("newindex in proxy")
        backing_proxy[key] = value
    end,
    __index = function(self, key)
        print("index in proxy")
        return backing_proxy[key]
    end
}

setmetatable(proxy, proxy_proxy)
setmetatable(table, proxy)

table.a = 0
```

obviously this wont work because how would table know about its metatable  
its metatable is the backing_proxy  
so it would need to do table -> check for __index in its metatable (__index not found) -> ckeck if the metatable of table has a metatable and if that metatable of the metatable has __index (and this step lua wont do)  

**🤓 am actualy you can use recursive __index by defining __index as a table in proxy**

yes you can define __index, in proxy to get a recusive call up to where you want but then the proxy table for __index wont work you cant detect if a __index is being overwritten becuase __index is already defined in proxy so __newindex of the poxy wont be called in the poxy_proxy  

thats why __override exists, to make proxied proxy tables posible  
by defining __override for the proxy you can catch __index for example, being overwritten  

#### BUT WHY??!!

its for my lua-oop project it makes heavy use of scopes,

a scope is just another layer of metatable pushed infront of the current _ENV while the old scope is set as __index of the new scope,

so a scope could look like this (inner/current scope to outer/old scope)

{ class = { name = ""} } => (__index) => { myImportedValue = 1, somotherimport = false } => (__index) => _ENV

**but whats the problem?? why do you need proxied proxy tables?**

well what is when the user wants to define a custom metamethod??

well the user is out of luck, every _ENV already has the common metamethods because of the OOP scoping system so i implementetd "mmtables" (Muli Meta tables)  
1 table can have more then 1 meta method of the same type by applying a poxy on the metatable, and because of the problem above a custom solution like __override is requred  

# Original README
This is Lua 5.4.6, released on 02 May 2023.

For installation instructions, license details, and
further information about Lua, see doc/readme.html.

