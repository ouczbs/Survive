local class = class(GA.Core,"Activity")

function class:ctor(initialActive)
    self.active = initialActive or false
    self.startTryers = GA.Core.Condition.new()
    self.stopTryers = GA.Core.Condition.new()
    self.onStop = GA.Core.Event.new()
    self.onStart = GA.Core.Event.new()
end

function class:addStartSC(obj, tryer)
    self.startTryers:addSCListener(obj, tryer)
end
function class:addStartNC(obj, tryer)
    self.startTryers:addNCListener(obj, tryer)
end

function class:addStopSC(obj, tryer)
    self.stopTryers:addSCListener(obj, tryer)
end
function class:addStopNC(obj, tryer)
    self.stopTryers:addNCListener(obj, tryer)
end
function class:AddStartListener(obj,callback)
    self.onStart:addListener(obj, callback)
end
function class:AddStopListener(obj,callback)
    self.onStop:addListener(obj, callback)
end

function class:forceStart()
    if self.active then
        return false
    end
    self.active = true
    self.onStart:call()
    return true
end

function class:forceStop()
    if not self.active then
        return false
    end
    self.active = false
    self.onStop:call()
    return true
end

function class:setActive(active , ...)
    if active ~= self.active then
        self:tryStop(...)
        if active then 
            self:tryStart(...)
        end
    end
end

function class:tryStart(...)
    if self.active then
        return false
    end
    local flag = self.startTryers:callApprovers(...)
    if flag then
        self.active = true
        self.onStart:call(...)
    end
    return self.active
end

function class:tryStop(...)
    if not self.active then
        return false
    end
    local flag = self.stopTryers:callApprovers(...)
    if flag then
        self.active = false
        self.onStop:call(...)
    end
    return not self.active
end

return class