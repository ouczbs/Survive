
local class = class(GA.Input, "Button")

local var = GA.Core.Var
function class:ctor()
    self.state = GA.Input.EButtonState.Released
    self.callbacks = {}
end

function class:isPressed()
    return self.state == GA.Input.EButtonState.Pressed
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
    self.state = newvalue
end

function class:pressed()
    self.state = GA.Input.EButtonState.Pressed
end

function class:released()
    self.state = GA.Input.EButtonState.Released
end

function class:get()
    return self.state
end