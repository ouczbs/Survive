require "UnLua"
local class = Class(GA.Building, "MasterBuildingPart")

--GameWorld.Building.MasterBuildingPart
function class:Lua_GetBuildingComponent()
    return gWorld.BuildingManager.buildingAbility.PlayerBuildingComponent
end

return class