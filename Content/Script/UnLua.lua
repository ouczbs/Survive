local rawget = rawget
local rawset = rawset
local type = type
local getmetatable = getmetatable
local setmetatable = setmetatable
local require = require
local str_sub = string.sub

local GetUProperty = GetUProperty
local SetUProperty = SetUProperty
local RegisterClass = RegisterClass
local RegisterEnum = RegisterEnum
local print = UEPrint
_NotExist = _NotExist or {}
local NotExist = _NotExist
if WITH_LUAIDE_DEBUG then
    require("socket.core")
    require("LuaPanda").start("127.0.0.1",8818)
end
local function Index(t, k)
	local mt = getmetatable(t)
	local super = mt
	while super do
		local v = rawget(super, k)
        if v~= nil then
            if rawequal(v, NotExist) then
                return nil
            end
			rawset(t, k, v)
			return v
		end
		super = rawget(super, "Super")
	end
    local p = mt[k]

    if p ~= nil then
        if type(p) == "userdata" then
            return GetUProperty(t, p)
        elseif type(p) == "function" then
            rawset(t, k, p)
        elseif rawequal(p, NotExist) then
            return nil
        end
    else
        rawset(mt, k, NotExist)
    end
	return p
end

local function NewIndex(t, k, v)
	local mt = getmetatable(t)
	local p = mt[k]
	if type(p) == "userdata" then
		return SetUProperty(t, p, v)
	end
	rawset(t, k, v)
end

local function Class(module , class_name , super_class)
	local new_class = {}
	if super_class then 
		for k,v in pairs(super_class) do new_class[k] = v end
	end
	new_class.__index = Index
	new_class.__newindex = NewIndex
	new_class.__cname = class_name
	if module ~= nil then
        module[class_name] = new_class
    end
    return new_class
end
local function logE(...)
	print("error ******************************")
	print(...)
end
__G__TRACKBACK__ = function(msg)
	local message = msg;

    -- auto genretated
	local msg = debug.traceback(msg, 3)
	
	logE(msg)

    -- report lua exception
    buglyReportLuaException(tostring(message), debug.traceback())
	return msg
end
local function import(resource)
	return UClass.Load(resource)
end

local function UClass_index(t, k)
	local v = rawget(t, k)
	if v then
		return v
    end
	RegisterClass(k)
	v = rawget(_G, k)
	rawset(t, k, v)
	rawset(_G, k, nil)
	return v
end

local function UEnum_index(t, k)
	local v = rawget(t, k)
	if v then
		return v
    end
    RegisterEnum(k)
	v = rawget(_G, k)
	rawset(t, k, v)
	rawset(_G, k, nil)
	return v
end
UE4 = {}
UEnum = {}
setmetatable(UE4, {__index = UClass_index })
setmetatable(UEnum, {__index = UEnum_index })
local GA = {
	initManagerList = {} ,
}
function GA:AddInitManager(name , UManager) 
	self.initManagerList[name] = UManager
end

_G.GA = GA
_G.import = import
_G.Class = Class
_G.print = print
_G.Index = Index
_G.NewIndex = NewIndex
_G.logE = logE
print("*****************Unlua******************")