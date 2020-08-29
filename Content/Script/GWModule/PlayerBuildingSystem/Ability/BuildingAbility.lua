require "UnLua"
local class = Class(GA.Ability, "BuildingAbility")

function class:GetUnluaBind()
    return GA.BpClass.BP_BuildingAbility,"GWModule.PlayerBuildingSystem.Ability.BuildingAbility"
end

function class:init()
end

function class:beginPlay()
    print("BuildingAbility beginplay")
end

function class:ReceiveBeginPlay()
    print("BuildingAbility beginplay")
end

return class
