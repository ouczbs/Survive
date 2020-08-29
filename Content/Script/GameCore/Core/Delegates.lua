local class = {}
GA.Core.Delegates = class
function class:new()
	return setmetatable({}, self)
end

function class.__call(t, _params)
	for _k, _v in pairs(t) do
		local param = {}
		table.insert(param, _v.owner)
		for i, v in pairs(_v.params) do
			table.insert(param, v)
		end
		local len = #param
		for i = 1, table.maxn(_params) do
			param[len + i] = _params[i]
		end
		_v.func(table.unpack(param, 1, table.maxn(param)))
	end
end

class.__index = {}

function class.__index:attach(func, owner, ...)
	local info = {func = func, owner = owner, params = {...}}
	for i = 1, table.maxn(self) do
		if self[i] == nil then
			self[i] = info
			return i
		end
	end
	local index = table.maxn(self) + 1
	self[index] = info
	return index
end

function class.__index:detachByFunc(func, owner)
	for i = 1, table.maxn(self) do
		if self[i] ~= nil then
			if self[i].func == func then
				if self[i].owner == owner then
					self[i] = nil
				end
			end
		end
	end
	return table.maxn(self)
end

function class.__index:detachById(id)
	self[id] = nil
	return table.maxn(self)
end