require "UnLua"
print("GameWorld.Character.PlayCharacter")
local class = Class(GA.Character ,"PlayCharacter")
function class:Initialize(Initializer)
    self.super.Initialize(self)
    print("Initializer PlayCharacter")
end
function class:ReceiveBeginPlay()
    --self:AddTickPrerequisiteActor(self.Mesh)
    print("ReceiveBeginPlay PlayCharacter")
end
--[[

function class:Initialize(Initializer)
    local rotation = self:K2_GetActorRotation()
    self.LastVelocityRotation = rotation
    self.LookingRotation = rotation
    self.LastMovementInputRotation = rotation
    self.TargetRotation = rotation
    self.CharacterRotation = rotation

    print("Initialize BaseCharacter")
end
-- "未完成"
function class:setArrowValues(Invisible)
    if self.Arrows:IsVisible() or Invisible then
        self.CharacterRotationArrow:K2_SetWorldRotation( self.CharacterRotation)
        self.LookingRotationArrow:K2_SetWorldRotation( self.LookingRotation)
        self.TargetRotationArrow:K2_SetWorldRotation( self.TargetRotation)
        self.MovementInputArrow:K2_SetWorldRotation( self.CharacterRotation)
        self.LastMovementInputRotationArrow:K2_SetWorldRotation( self.CharacterRotation)
        
        self.FP_Camera:K2_AttachToComponent( self.Mesh, self.FirstPersonCameraSocket)
    end
end


function class:ReceiveBeginPlay()
    self.Mesh:AddTickPrerequisiteActor(self)
    --self:setArrowValues(true)
    print(self.FirstPersonCameraSocket)
    self:viewModeChanged()
    local animInstance = self.Mesh:GetAnimInstance()
    --UE4.UALS_Interface_C["Set ALS_ViewMode BPI"](animInstance, self.ViewMode )
    --print(UE4.UALS_Interface_C["Set ALS_ViewMode BPI"],"==================")
    --print("ReceiveBeginPlay BaseCharacter")
end
    
function class:viewModeChanged()

end
--]]
return class