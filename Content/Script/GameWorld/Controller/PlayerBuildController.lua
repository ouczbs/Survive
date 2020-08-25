
local class = Class(GA.Controller ,"PlayerBuildController")

function class:Initialize(Initializer)
    print("Initialize PlayerBuildController")
end
function class:GetUnluaBind()
    return GA.BpClass.BP_PlayerBuildController,"GameWorld.Character.PlayerBuildController"
end
function class:ReceiveEndPlay()
    print("ReceiveEndPlay PlayerBuildController")
end
return class