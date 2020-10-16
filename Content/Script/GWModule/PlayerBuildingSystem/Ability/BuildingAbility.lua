require "UnLua"
local class = Class(GA.Ability, "BuildingAbility")

function class:Initialize(Initializer)
    self:initInputEvent()
end
function class:initInputEvent()
    self.isInBuildingMode = false
    gWorld.InputManager:registerLuaInput("BuildingMode_Pressed" , self.BuildingMode_Pressed , self)
    gWorld.InputManager:registerLuaInput("Interactive_Pressed" , self.Interactive_Pressed , self)

end

function class:BuildingMode_Pressed()
    local mode = not self.isInBuildingMode
    self.isInBuildingMode = mode
    self.PlayerBuildingComponent["Toggle Build Menu"](self.PlayerBuildingComponent , mode)
end


function class:Interactive_Pressed()
    self.PlayerBuildingComponent["Left Mouse Pressed"](self.PlayerBuildingComponent , false)
end


return class
