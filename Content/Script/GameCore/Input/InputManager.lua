local class = class(GA.Input, "InputManager")

function class:ctor()
	self.axisBindings = {}

	self.actionBindings = {}
end


function class:init()
	self._worldInput = GA.Input.InputEvent.new()
end

function class:destroy()
	self.axisBindings = nil

	self.actionBindings = nil
end

function class:bindAction(actionName, keyEventIndex, func , owner)
	if not self.actionBindings[actionName] then 
		self.actionBindings[actionName] = {}
	end
	return self._worldInput and self._worldInput:registerLuaInput(keyEventIndex, func, owner)
end

function class:unBindAction(actionName, keyEventIndex , func, owner)
	if not self.actionBindings[actionName] then 
		return
	end
	return self._worldInput and self._worldInput:unRegisterLuaInput(keyEventIndex, func, owner)
end

function class:bindAxis(axisName, func , owner)
	return self._worldInput and self._worldInput:registerLuaInput(axisName, func, owner)
end

function class:unBindAxis(axisName , func , owner)
	return self._worldInput and self._worldInput:unRegisterLuaInput(axisName, func, owner)
end

function class:resetAction(actionName)
	self.actionBindings[actionName] = nil
end

function class:resetAxis(axisName)
	self.axisBindings[axisName] = nil
end