
local super = GA.Character.ALS_BaseCharacter
local class = Class(GA.Character ,"ALS_Character" , super)

function class:Initialize(Initializer)
    super.Initialize(self , Initializer)
end

return class