
local class = class(GA.Player, "PlayerNet")
-- begin with b means blueprint
function class:ctor(control)
    self.b_control = control
    self.b_player = control.Pawn

    self.m_playerInput = GA.Player.PlayerInputHandle.new()
    self.m_playerEntity =GA.Player.PlayerEntityHandle.new()

    self.b_anim = self.b_player.Mesh:GetAnimInstance()

    self:beginPlay()
end
function class:getPlayerInputHandle()
    return self.m_playerInput
end
function class:tick(dt)
    self:doTick(dt)
    
end
-- doTick 更新所有客户端数据 本地动画则立即执行
function class:doTick(dt)
    if self.b_player.ALS_MovementMode ~= EALS_MovementMode.Ragdoll then
        self:MovementInput()
        self:LookTurn(dt)
    else 
        
    end
end

function class:calcuteDirection(txt)
    local velocity= self.b_player:GetVelocity()
    local zero = UE4.FVector(0, 0, 0)
    local notZero = UE4.UKismetMathLibrary.NotEqual_VectorVector(velocity ,zero)
    if notZero then
        local LastVelocityRotation = UE4.UKismetMathLibrary.Conv_VectorToRotator(velocity)
        local diff = UE4.UKismetMathLibrary.NormalizedDeltaRotator(velocity)
        self.b_player.Direction = diff.Yaw
    end
end

function class:LookTurn(dt)
    self.b_control:AddPitchInput(self.m_playerInput.LookUp * self.m_playerInput.LookUpRate *dt)
    self.b_control:AddYawInput(self.m_playerInput.LookRight * self.m_playerInput.LookRightRate *dt)
end

function class:MovementInput()
    local rotation = self.b_control:K2_GetActorRotation()
    self.rotation.Yaw = rotation.Yaw
    self:MoveForward()
    self:MoveRight()
end

function class:lateTick()
    
end

function class:MoveForward()
    if self.m_playerInput.ForwardAxisValue ~= 0 then
        local direction = UE4.UKismetMathLibrary.GetForwardVector(self.rotation)
        self.b_player:AddMovementInput(direction, self.m_playerInput.ForwardAxisValue)
    end
end

function class:MoveRight()
    if self.m_playerInput.RightAxisValue ~= 0 then
        local direction = UE4.UKismetMathLibrary.GetRightVector(self.rotation)
        self.b_player:AddMovementInput(direction, self.m_playerInput.RightAxisValue)
    end
end
function class:beginPlay()
    self.rotation = UE4.FRotator(0 , 0, 0)
    self.m_playerInput.JumpAction:AddStartListener(self, "Start_JumpAction")
    self.m_playerInput.JumpAction:AddStartListener(self, "Stop_CrouchAction")
    self.m_playerInput.JumpAction:AddStopListener(self, "Stop_JumpAction")

    self.m_playerInput.CrouchAction:AddStartListener(self, "Start_CrouchAction")
    self.m_playerInput.CrouchAction:AddStopListener(self, "Stop_CrouchAction")

    self.m_playerInput.SprintAction:AddStartListener(self, "Start_SprintAction")
    self.m_playerInput.SprintAction:AddStopListener(self, "Stop_SprintAction")

end
function class:Start_JumpAction()
    self.b_player:Jump()
end

function class:Stop_JumpAction()
    self.b_player:StopJumping()
end

function class:Start_CrouchAction()
    self.b_player:Crouch()
end
function class:Stop_CrouchAction()
    self.b_player:UnCrouch()
end
function class:Start_SprintAction()
    self.b_player.ShouldSprint = true
end
function class:Stop_SprintAction()
    self.b_player.ShouldSprint = false
end

function class:doWhileGround()
    local value = self.b_player.
    UE4.UKismetMathLibrary.MapRangeClamped(45, 130, 1, 0.2)
end 
return class