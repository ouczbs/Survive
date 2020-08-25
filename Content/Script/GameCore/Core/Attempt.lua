local class = class(GA.Core,"Attempt")

function class:ctor()
    self.tryers = GA.Core.Event.new()
    self.callbacks = GA.Core.Event.new()
end

function class:addTryer(obj, tryer)
    self.tryers:addListener(obj, tryer)
end
function class:removeTryer(obj, tryer)
    self.tryers:removeListener(obj, tryer)
end

function class:addListener(obj,callback)
    self.callbacks:addListener(obj, callback)
end

function class:removeListener(obj,callback)
    self.callbacks:removeListener(obj, callback)
end

function class:try(...)
    local flag = self.tryers:callApprovers(...)
    if flag then
        self.callbacks:call(...)
    end
    return flag
end

return class