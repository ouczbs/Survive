
local class = class(GA.Interface, "InterfaceBus")

function class:ctor()
    self._worldLuaEvent = self:_createLuaInterface()

end

function class:init()

end

function class:destroy()
   
end

function class:_createLuaInterface()
   return GA.Interface.LuaInterface.new()
end

function class:registerLuaInterface(eventID, func, owner, ...)
    return self._worldInterface and self._worldInterface:registerLuaInterface(eventID, func, owner, ...)
end

function class:unRegisterLuaInterface(eventID, func, owner, ...)
    return self._worldInterface and self._worldInterface:unRegisterLuaInterface(eventID, func, owner, ...)
end