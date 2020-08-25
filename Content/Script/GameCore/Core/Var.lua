local class = class(GA.Core,"Var")

function class:ctor(var)
    self.var = var
end

function class:set(newVar)
    self.var = newVar
end

function class:get()
    return self.var
end

function class:empty()
    return self.var == nil
end
return class