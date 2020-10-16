

require "UnLua"
local class = Class(GA.Character ,"CharacterAnim")


function class:tick(dt)
    
end

function class:beginPlay()
    self.ALS_BaseCharacter = self:TryGetPawnOwner()
    self.CharacterMovement = self.ALS_BaseCharacter.CharacterMovement
    self.CapsuleComponent = self.ALS_BaseCharacter.CapsuleComponent
    --UE4.UALS_Interface_C.ChangeTest(self,12)

    local pawn = self:TryGetPawnOwner()
    local anim = pawn.Mesh:GetAnimInstance()
end

function class:SetDefaultValues()
    UE4.UALS_Interface_C["Set ALS_MovementMode BPI"](self, self.ALS_BaseCharacter.ALS_MovementMode)
    UE4.UALS_Interface_C["Set ALS_Gait BPI"](self, self.ALS_BaseCharacter.ALS_Gait)
    UE4.UALS_Interface_C["Set ALS_Stance BPI"](self, self.ALS_BaseCharacter.ALS_Stance)
    UE4.UALS_Interface_C["Set ALS_RotationMode BPI"](self, self.ALS_BaseCharacter.ALS_RotationMode)
    UE4.UALS_Interface_C["Set ALS_ViewMode BPI"](self, self.ALS_BaseCharacter.ALS_ViewMode)
    UE4.UALS_Interface_C["Set ALS_Aiming BPI"](self, self.ALS_BaseCharacter.ALS_Aiming)

    UE4.UALS_Interface_C["Set WalkingSpeed BPI"](self, self.ALS_BaseCharacter.WalkingSpeed)
    UE4.UALS_Interface_C["Set SprintingSpeed BPI"](self, self.ALS_BaseCharacter.SprintingSpeed)
    UE4.UALS_Interface_C["Set CrouchingSpeed BPI"](self, self.ALS_BaseCharacter.CrouchingSpeed)
    UE4.UALS_Interface_C["Set SprintingSpeed BPI"](self, self.ALS_BaseCharacter.SprintingSpeed)

    UE4.UALS_Interface_C.SetTest(self, 2.3)
    if self.ALS_Stance == UE4.EALS_Stance.Standing then
        self.IdleEntryState = UE4.EIdleEntryState.N_Idle
    else
        self.IdleEntryState = UE4.EIdleEntryState.CLF_Idle
    end

end

function class:lateTick(dt)

end

function class:BlueprintInitializeAnimation()
    gWorld.message_beginPlay:addListener(self , "beginPlay")
end

-- function class:BlueprintUpdateAnimation(dt)
     
-- end


return class
