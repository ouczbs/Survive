
--lua class : test_C
require "UnLua"
local class = Class(GA.Character ,"CharacterControl")
function class:ReceiveBeginPlay()
    gWorld.message_beginPlay:addListener(self , "beginPlay")
end
function class:tick()

end
function class:beginPlay()
    self.m_player = gWorld.playerNet:getPlayerInputHandle()
end

function class:MoveForward(axisValue)
    self.m_player.ForwardAxisValue = axisValue
end
function class:MoveRight(axisValue)
    self.m_player.RightAxisValue = axisValue
end

function class:LookUp(axisValue)
    self.m_player.LookUp = axisValue
end
function class:LookRight(axisValue)
    self.m_player.LookRight = axisValue
end

function class:JumpAction_Pressed()
    self.m_player.JumpAction:setActive(true)
end

function class:JumpAction_Released()
    self.m_player.JumpAction:setActive(false)
end
function class:StanceAction_Pressed()
    local cmd = self.m_player.CrouchAction:tryStart()
    if not cmd then
        self.m_player.CrouchAction:tryStop()
    end
end
function class:SprintAction_Pressed()
    self.m_player.SprintAction:setActive(true)
end

function class:SprintAction_Released()
    self.m_player.SprintAction:setActive(false)
end
return class