local class = {}
GA.Core.Delegate = class
function class:new()
	return setmetatable({}, self)
end

function class.__call(t, _params)
    local info = self.info
    local param = {}
    table.insert(param, info.owner)
    for i, v in pairs(info.params) do
        table.insert(param, v)
    end
    local len = #param
    for i = 1, table.maxn(_params) do
        param[len + i] = _params[i]
    end
    return info.func(table.unpack(param, 1, table.maxn(param)))
end

class.__index = {}

function class.__index:attach(func, owner, ...)
    self.info = {func = func, owner = owner, params = {...}}
end

function class.__index:detachByFunc(func, owner)
    local info = self.info
    if info then 
        if info.func == func and info.owner == owner then 
            self.info = nil
        end
    end 
end

function class.__index:detachById(id)
	self.info = nil
end