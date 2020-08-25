
local class = Class(GA.Character ,"ALS_Character")

function class:Initialize(Initializer)
    print("Initialize ALS_Character")
end
function class:GetUnluaBind()
    return GA.BpClass.ALS_AnimMan_CharacterBP,"GameWorld.Character.ALS_Character"
end
function class:ReceiveEndPlay()
    print("ReceiveEndPlay ALS_Character")
end
return class