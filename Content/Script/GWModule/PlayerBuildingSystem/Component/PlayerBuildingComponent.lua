
require "UnLua"
local class = Class(GA.Building, "BuildingMaster")

function class:Lua_BuildingTrace()
    local ignoreArray = self["Ignore Actor Array"]
    local rayStart,rayEnd = self["Get Trace Vector"]()
    local outHits, boolOut = UE4.UKismetSystemLibrary.LineTraceSingle(gWorld:getWorldContext(),rayStart , rayEnd ,250 , ETraceTypeQuery.Visibility ,false , ignoreArray , EDrawDebugTrace.None , {} , true)

end

return class