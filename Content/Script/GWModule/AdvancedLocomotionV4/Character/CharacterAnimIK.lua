
require "UnLua"
local class = Class(GA.Character ,"CharacterAnimIK")

function class:beginPlay()
    --local pawn = self:TryGetPawnOwner()
    --local anim = pawn.Mesh:GetAnimInstance()
end
function class:BlueprintInitializeAnimation()
    gWorld.message_beginPlay:addListener(self , "beginPlay")
end




return class