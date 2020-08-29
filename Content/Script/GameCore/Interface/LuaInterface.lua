
local class = class(GA.Interface, "LuaInterface")
local interfaceDelegate = GA.Core.Delegate
function class:ctor()
	self.interfaceContent = {}
end
function class:registerLuaInterface(interfaceID, func, owner, ...)
	if interfaceID == nil then
		logE("invalid interfaceID! check classEnum.lua.")
		return
	end
	if func == nil then
		logE("interface must have callback")
		return
	end
	if owner == nil then
		logE("interface must have owner.")
		return
	end
	self.interfaceContent[interfaceID] = self.interfaceContent[interfaceID] or interfaceDelegate:new()
	return self.interfaceContent[interfaceID]:attach(func, owner, ...)
end

function class:unRegisterLuaInterface(interfaceID, func_or_id, owner, ...)
	local t = type(func_or_id)
	local delegate = self.interfaceContent[interfaceID]
	local remain = 0
	if delegate ~= nil then
		if t == "number" then
			remain = delegate:detachById(func_or_id)
		elseif t == "function" then
			remain = delegate:detachByFunc(func_or_id, owner)
		else
			error("func_or_id is invalid!")
			return
		end
	end
	
	if remain <= 0 then
		self.interfaceContent[interfaceID] = nil
	end
end

function class:notifyInterface(interfaceID, ...)
	local delegate = self.interfaceContent[interfaceID]
    if delegate ~= nil then
        return delegate(params)
	end
end