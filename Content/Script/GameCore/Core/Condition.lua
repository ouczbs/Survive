local class = class(GA.Core,"Condition")

function class:ctor()
    self.sufficient = GA.Core.Event.new()
    self.necessary = GA.Core.Event.new()
end
function class:clear()
    self.sufficient:clear()
    self.necessary:clear()
end

function class:addSCListener(obj,callback)
    self.sufficient:addListener(obj,callback)
end
function class:addNCListener(obj,callback)
    self.necessary:addListener(obj,callback)
end

function class:removeSCListener(obj,callback)
    self.sufficient:removeListener(obj,callback)
end
function class:removeNCListener(obj,callback)
    self.necessary:removeListener(obj,callback)
end
function class:callApprovers(...)
    local flag = false
    if self.sufficient:callAnyApprovers() then 
        flag = true
    elseif self.necessary:callAllApprovers() then 
        flag = true
    end
    return flag
end
return class