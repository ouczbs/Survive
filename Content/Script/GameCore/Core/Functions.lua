--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]
local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end

function checknumber(value, base)
    return tonumber(value, base) or 0
end

function checkint(value)
    return math.round(checknumber(value))
end

function checkbool(value)
    return (value ~= nil and value ~= false)
end

function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

function isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        --@TODO: no tolua here
        --[[
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
        ]]
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function clone(object,shallow)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        if shallow then
            return new_table
        else
            return setmetatable(new_table, getmetatable(object))
        end
    end
    return _copy(object)
end

local classTb,hotswap = {},true
local function _unpack(t,i)
    i = i or 1
    if i <= #t then
        return t[i],_unpack(t,i+1)
    end
end
local function _pack(...)
    local n = select('#', ...)
    local t = {}
    for i = 1, n do
        t[i] = select(i, ...)
    end
    return t
end

function class(module, classname, super)
    if classname == nil and super == nil then
        module , classname = nil , module
    end
    local superType = type(super)
    local class
 
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end
 
    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        class = {}
 
        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do class[k] = v end
            class.__create = super.__create
            class.super    = super
        else
            class.__create = super
        end
 
        class.ctor    = function() end
        class.__cname = classname
        class.__ctype = 1
 
        function class.new(...)
            local instance = class.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(class) do instance[k] = v end
            instance.class = class
            instance:ctor(...)
            return instance
        end
 
    else
        -- inherited from Lua Object
        if super then
            -- class = clone(super)
            class = setmetatable({}, {__index = super})
            class.super = super
        else
            class = {ctor = function() end}
        end
 
        class.__cname = classname
        class.__ctype = 2 -- lua
        class.__index = class
 
        function class.new(...)
            local instance = setmetatable({}, class)
            -- local instance = clone(class)
            -- instance = setmetatable(instance, instance.super)
            instance.class = class
            instance:ctor(...)
            return instance
        end
    end
    
    if module ~= nil then
        module[classname] = class
    end
    return class
end

function isKindofClass(obj, class)
    local t = type(obj)
    if t ~= "table" then return false end

    local mt = obj.class
    while mt do
        if mt == class then
            return true
        else
            mt = mt.super
        end
    end
    return false
end

function class_new(classname, ...)
    local class = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(class.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            class.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(class.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                class.__create = function() return super:create() end
            else
                -- super is pure lua class
                class.__supers = class.__supers or {}
                class.__supers[#class.__supers + 1] = super
                if not class.super then
                    -- set first super pure lua class as class.super
                    class.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    class.__index = class
    if not class.__supers or #class.__supers == 1 then
        setmetatable(class, {__index = class.super})
    else
        setmetatable(class, {__index = function(_, key)
            local supers = class.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not class.ctor then
        -- add default constructor
        class.ctor = function() end
    end
    class.new = function(...)
        local instance
        if class.__create then
            instance = class.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, class)
        instance.class = class
        instance:ctor(...)
        return instance
    end
    class.create = function(_, ...)
        return class.new(...)
    end

    return class
end

local iskindof_
iskindof_ = function(class, name)
    local __index = rawget(class, "__index")
    if type(__index) == "table" and rawget(__index, "__cname") == name then return true end

    if rawget(class, "__cname") == name then return true end
    local __supers = rawget(class, "__supers")
    if not __supers then return false end
    for _, super in ipairs(__supers) do
        if iskindof_(super, name) then return true end
    end
    return false
end

function iskindof(obj, classname)
    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then return false end

    local mt
    if t == "userdata" then
        -- TODO: reg a typeof method from slua
        --[[
        if tolua.iskindof(obj, classname) then return true end
        mt = tolua.getpeer(obj)
        ]]
    else
        mt = getmetatable(obj)
    end
    if mt then
        return iskindof_(mt, classname)
    end
    return false
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

-- @Nullptr and null UObject.
function isValid(_object)
    if _object then
        --@strange that this method often causes an exception when using PreviewLine.
        --local kismet = import("KismetSystemLibrary")
        --return kismet:IsValid(_object)
        return true
    else
        return false
    end
end

local unpack = table.unpack
function toDelegate(func, ...)
	local args = {...}
	local function callback(...)
		if select('#', ...) == 0 then
			func(unpack(args))
		else
			local len = #args
			if len == 0 then
				func(...)
			elseif len == 1 then
				func(args[1], ...)
			else
				local new_args = {}
				for i,v in pairs(args) do
					table.insert(new_args,v)
				end
				for i,v in pairs({...}) do
					table.insert(new_args,v)
				end
				func(unpack(new_args))
			end
		end
	end
	return callback
end

--------------------------------------------------------------------------------
-- 序列化为字符串 ...
--------------------------------------------------------------------------------
function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
    for k, v in pairs(obj) do
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

--------------------------------------------------------------------------------
-- 从字符串反序列化 ...
--------------------------------------------------------------------------------
function unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    -- 5.3 replaced loadstring with load
    local func = load(lua)
    if func == nil then
        return nil
    end
    return func()
end

-- @Note: this is only a simplicity to avoid writing if-else, while
-- taking no responsibility to call a interrupt and return to parent stack.
-- The reason lua assert is not recommanded to use is that it has a chance leading
-- to memory leak in our project.
function check(condition, msg)
    if not condition then
        logE(msg)
    end
end
