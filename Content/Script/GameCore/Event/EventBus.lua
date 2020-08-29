local EventBus = class(GA.Event, "EventBus")

function eventFuncGenerator(name, eventGetter)
    local registerFunc = "register" .. name
    local unregisterFunc = "unRegister" .. name
    local notifyFunc = "notify" .. name
    EventBus[registerFunc] = function (self, keyToDispatcher, eventId, func, owner, ...)
        local event = eventGetter(self, keyToDispatcher)
        if event then
            return event:registerLuaEvent(eventId, func, owner, ...)
        end
    end

    EventBus[unregisterFunc] = function (self, keyToDispatcher, eventId, func_or_id, owner)
        local event = eventGetter(self, keyToDispatcher)
        if event then
            return event:unRegisterLuaEvent(eventId, func_or_id, owner)
        end
    end

    EventBus[notifyFunc] = function (self, keyToDispatcher, eventId, ...)
        local event = eventGetter(self, keyToDispatcher)
        if event then
            return event:notifyEvent(eventId, ...)
        end
    end
end

eventFuncGenerator("CharacterEvent", function(self, key) return self._characterEvents and self._characterEvents[key] end)

eventFuncGenerator("StageObjectEvent", function(self, key) return self._stageObjectEvents and self._stageObjectEvents[key] end)

function EventBus:ctor()
    self._worldLuaEvent = self:_createLuaEvent()
    self._characterEvents = {}
    self._stageObjectEvents = {}

    -- init
    -- eventFuncGenerator("LuaEvent", function() return self._worldLuaEvent end)

    -- register
	-- self:registerLuaEvent(gLuaEventType.CHARACTERMANGER.CHARACTER_APPEAR, EventBus.onCharacterAppear, self)
	-- self:registerLuaEvent(gLuaEventType.CHARACTERMANGER.CHARACTER_DISAPPEAR, EventBus.onCharacterDisappear, self)
end
function EventBus:init()

end
function EventBus:destroy()
    -- gWorld.eventBus:unRegisterLuaEvent(gLuaEventType.CHARACTERMANGER.CHARACTER_APPEAR, EventBus.onCharacterAppear)
    self._worldLuaEvent = nil
    self._characterEvents = nil
    self._stageObjectEvents = nil
	-- self:unRegisterLuaEvent(gLuaEventType.CHARACTERMANGER.CHARACTER_APPEAR, EventBus.onCharacterAppear, self)
	-- self:unRegisterLuaEvent(gLuaEventType.CHARACTERMANGER.CHARACTER_DISAPPEAR, EventBus.onCharacterDisappear, self)
end

function EventBus:registerLuaEvent(eventID, func, owner, ...)
    return self._worldLuaEvent and self._worldLuaEvent:registerLuaEvent(eventID, func, owner, ...)
end

function EventBus:unRegisterLuaEvent(eventID, func_or_id, owner)
    return self._worldLuaEvent and self._worldLuaEvent:unRegisterLuaEvent(eventID, func_or_id, owner)
end

function EventBus:notifyEvent(eventID, ...)
    return self._worldLuaEvent and self._worldLuaEvent:notifyEvent(eventID, ...)
end

function EventBus:onCharacterAppear(inCharacter)
    if inCharacter then
        self._characterEvents[inCharacter] = self:_createLuaEvent()
    end
end

function EventBus:onCharacterDisappear(inCharacter)
    if inCharacter then
        self._characterEvents[inCharacter] = nil
    end
end

function EventBus:createStageObjectEvent(object)
    if object then
        self._stageObjectEvents[object] = self:_createLuaEvent()
    end
end

function EventBus:removeStageObjectEvent(object)
    if object then
        self._stageObjectEvents[object] = nil
    end
end

function EventBus:_createLuaEvent()
    return GA.Event.LuaEvent.new()
end