local class = class(GA.Event, "EventBus")
function class:ctor()
    self._worldLuaEvent = self:_createLuaEvent()
    self._characterEvents = {}
    self._stageObjectEvents = {}

end
function class:init()

end
function class:destroy()
    self._worldLuaEvent = nil
    self._characterEvents = nil
    self._stageObjectEvents = nil
end

function class:registerLuaEvent(eventID, func, owner, ...)
    return self._worldLuaEvent:registerLuaEvent(eventID, func, owner, ...)
end

function class:unRegisterLuaEvent(eventID, func_or_id, owner)
    return self._worldLuaEvent:unRegisterLuaEvent(eventID, func_or_id, owner)
end

function class:notifyEvent(eventID, ...)
    return self._worldLuaEvent:notifyEvent(eventID, ...)
end

function class:onCharacterAppear(inCharacter)
    if inCharacter then
        self._characterEvents[inCharacter] = self:_createLuaEvent()
    end
end

function class:onCharacterDisappear(inCharacter)
    if inCharacter then
        self._characterEvents[inCharacter] = nil
    end
end

function class:createStageObjectEvent(object)
    if object then
        self._stageObjectEvents[object] = self:_createLuaEvent()
    end
end

function class:removeStageObjectEvent(object)
    if object then
        self._stageObjectEvents[object] = nil
    end
end

function class:_createLuaEvent()
    return GA.Event.LuaEvent.new()
end