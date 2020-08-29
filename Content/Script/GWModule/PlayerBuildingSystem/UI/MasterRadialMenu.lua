require "UnLua"
local class = Class(GA.UI.Building, "MasterRadialMenu")

--GameWorld.UI.Building.MasterRadialMenu
function class:Lua_GetBuildingComponent()
    return gWorld.BuildingManager.buildingAbility.PlayerBuildingComponent
end

return class
