local class = class(GA.Input, "InputEvent")

local delegates = GA.Core.Delegates

function class:ctor()
	self.eventContent = {}
end

function class:registerLuaInput(eventID, func, owner, ...)
	if eventID == nil then
		logE("invalid eventID! check classEnum.lua.")
		return
	end
	if func == nil then
		logE("event must have callback")
		return
	end
	if owner == nil then
		logE("event must have owner.")
		return
	end
	self.eventContent[eventID] = self.eventContent[eventID] or eventDelegate:new()
	return self.eventContent[eventID]:attach(func, owner, ...)
end

function class:unRegisterLuaInput(eventID, func_or_id, owner, ...)
	local t = type(func_or_id)
	local delegate = self.eventContent[eventID]
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
		self.eventContent[eventID] = nil
	end
end

function class:notifyInput(eventID, ...)
	local delegate = self.eventContent[eventID]
    if delegate ~= nil then
        local params = {...}
		local state, err = xpcall(function() delegate(params) end, __G__TRACKBACK__)
		if not state then
			logE(eventID .. " error:" .. err)
		end
	end
end