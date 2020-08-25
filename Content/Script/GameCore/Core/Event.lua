local class = class(GA.Core,"Event")

function class:ctor()
    self.events = {}
end
function class:clear()
    self.events = {}
end

function class:addListener(obj,callback)
    local callbacks = self.events[obj]
    if callbacks then
        callbacks[callback] = true
    else
        callbacks = {}
        callbacks[callback] = true
        self.events[obj] = callbacks
    end
end

function class:removeListener(obj,callback)
    local event = self.events[obj]
    if event then
        event[callback] = nil
    end
end

function class:call(...)
    for obj, callbacks in pairs(self.events) do
        for cname, _ in pairs(callbacks) do 
            local event = obj[cname]
            event(obj,...)
        end
    end
end
function class:callAllApprovers(...)
    local flag = true
    for obj, callbacks in pairs(self.events) do
        for cname, _ in pairs(callbacks) do 
            local event = obj[cname]
            flag = event(obj,...)
            if not flag then return flag end
        end
    end
    return flag
end
function class:callAnyApprovers(...)
    local flag = false
    for obj, callbacks in pairs(self.events) do
        for cname, _ in pairs(callbacks) do 
            local event = obj[cname]
            flag = event(obj,...)
            if flag then return flag end
        end
    end
    return flag
end
return class