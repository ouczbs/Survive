
local class = Class(GA.Character ,"ALS_BaseCharacter")

function class:Initialize(Initializer)
    self:initInputEvent()
end
function class:initInputEvent()
    
    gWorld.InputManager:registerLuaInput("JumpAction_Pressed" , self.JumpAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("WalkAction_Pressed" , self.WalkAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("StanceAction_Pressed" , self.StanceAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("RollAction_Pressed" , self.RollAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("SprintAction_Pressed" , self.SprintAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("SprintAction_Released" , self.SprintAction_Released , self)
    gWorld.InputManager:registerLuaInput("AimAction_Pressed" , self.SprintAction_Pressed , self)
    gWorld.InputManager:registerLuaInput("AimAction_Released" , self.SprintAction_Released , self)

end
function class:JumpAction_Pressed()
    if self.MovementAction ~= UEnum.ALS_MovementAction.None then 
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.Mantling then 
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.Ragdoll then 
        self:RagdollEnd()
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.Grounded then 
        if self.HasMovementInput then 
            local canClimb = self:MantleCheck(self.GroundedTraceSettings , UEnum.EDrawDebugTrace.DebugType)
            if canClimb then 
                return 
            end
        end
        if self.Stance == UEnum.ALS_Stance.Standing then 
            self:Jump()
        elseif self.Stance == UEnum.ALS_Stance.Crouching then
            self:UnCrouch()
        end
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.InAir then 
        self:MantleCheck(self.FallingTraceSettings , UEnum.EDrawDebugTrace.DebugType)
        return
    end
end
function class:WalkAction_Pressed()
    if self.DesiredGait == UEnum.ALS_Gait.Walking then 
        self.DesiredGait = UEnum.ALS_Gait.Running
        return
    end
    if self.DesiredGait == UEnum.ALS_Gait.Running then 
        self.DesiredGait = UEnum.ALS_Gait.Walking
        return
    end
end

function class:StanceAction_Pressed()
    if self.MovementAction ~= UEnum.ALS_MovementAction.None then 
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.InAir then 
        self.BreakFall = true
        UE4.UKismetSystemLibrary.RetriggerableDelay(gWorld:getWorldContext() , 0.4 , function ()
            self.BreakFall = false
        end)
        return
    end
    if self.MovementState == UEnum.ALS_MovementState.Grounded then 
        if self.Stance == UEnum.ALS_Stance.Standing then 
            self.DesiredStance = UEnum.ALS_Stance.Crouching
            self:Crouch()
        elseif self.Stance == UEnum.ALS_Stance.Crouching then
            self.DesiredStance = UEnum.ALS_Stance.Standing
            self:UnCrouch()
        end
    end
end

function class:SprintAction_Pressed()
    self.DesiredGait = UEnum.ALS_Gait.Sprinting
end
function class:SprintAction_Released()
    self.DesiredGait = UEnum.ALS_Gait.Running
end
function class:AimAction_Pressed()
    self:BPI_Set_RotationMode(UEnum.ALS_RotationMode.Aiming)
end
function class:AimAction_Released()
    if self.ViewMode == UEnum.ALS_ViewMode.ThirdPerson then 
        self:BPI_Set_RotationMode(self.DesiredRotationMode)
        return
    end
    if self.ViewMode == UEnum.ALS_ViewMode.FirstPerson then 
        self:BPI_Set_RotationMode(UEnum.ALS_RotationMode.LookingDirection)
        return
    end
end
function class:RollAction_Pressed()
    if self.MovementAction ~= UEnum.ALS_MovementAction.None then 
        return
    end
    self["Roll Event"](self)
end