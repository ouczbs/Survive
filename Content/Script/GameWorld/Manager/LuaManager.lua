--lua class : test_C
require "UnLua"
local class = Class(GA.Manager, "LuaManager")
function class:GetUnluaBind()
    return GA.BpClass.BP_LuaManager,"GameWorld.Manager.LuaManager"
end
function class:beginPlay()

end
return class


