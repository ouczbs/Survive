local class = class(GA.Input, "InputManager")

function class:ctor()
	self.axisBindings = {}

	self.actionBindings = {}
end


function class:init()
	self._worldInput = GA.Input.InputEvent.new()
end

function class:registerLuaInput(inputId, func , owner)
	return self._worldInput:registerLuaInput(inputId, func, owner)
end

function class:unRegisterLuaInput(inputId , func , owner)
	return self._worldInput:unRegisterLuaInput(inputId, func, owner)
end

function class:notifyInput(inputId, ...)
    return self._worldInput:notifyInput(inputId, ...)
end
GA:AddInitManager(class.__cname , class)