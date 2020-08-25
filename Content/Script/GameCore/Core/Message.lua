
local class = class(GA.Core,"Message")

function class:ctor()
    self.listens = GA.Core.Event.new()
    self.active = false
end

function class:reset()
    self.active = false
end

function class:addListener(obj,callback)
    if self.active then
        local event = obj[callback]
        event(obj)
    else
        self.listens:addListener(obj, callback)
    end
end

function class:removeListener(obj, callback)
    self.listens:removeListener(obj, callback)
end

function class:send()
    self.active = true
    self.listens:call()
    self.listens:clear()
end

return class