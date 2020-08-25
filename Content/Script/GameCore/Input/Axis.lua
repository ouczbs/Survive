
local class = class(GA.Input, "Axis")
function class:ctor()
    self.value = 0
    self.callbacks = {}
end

function class:addChangeListener(callback)
    self.callbacks[callback] = callback
end

function class:removeChangeListener(callback)
    self.callbacks[callback] = nil
end

function class:clear()
    for _,callback in pairs(self.callbacks) do
        callback()
    end
end

function class:set(newvalue)
    self.value = newvalue
end

function class:get()
    return self.value
end