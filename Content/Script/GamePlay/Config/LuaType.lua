local Enum = { id = 0, }
function Enum.new(id)
    return setmetatable({id = id}, {
        __index = function (t, k)
            local v = rawget(t,k)
            if not v then 
                local id = rawget(Enum,"id")
                v = Enum.new(id + 1)
                rawset(t,k,v)
                rawset(Enum,"id", id + 1)
            end
            return v
        end
        })
end
GA.Config.LuaType = GA.Config.LuaType or Enum.new()