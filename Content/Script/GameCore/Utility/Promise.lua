
local class = class(GA.Utility, "Promise")

function class.Then(callback,bridge , ...)
    if bridge.next then 
        bridge.next = nil
        callback(bridge , ...)
    end
    return class
end