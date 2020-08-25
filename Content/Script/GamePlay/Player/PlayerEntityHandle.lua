
local super = GA.Entity.EntityEventHandle
local class = class(GA.Player, "PlayerEntityHandle", super)

-- local value = GA.Core.Value
-- local message = GA.Core.Message
-- local activity = GA.Core.Activity
function class:ctor()
    super.ctor(self)
    self.hunger = GA.Core.Value.new(100)
    self.speed = GA.Core.Value.new(0)
    self.RightAxisValue = 0
    self.ForwardAxisValue = 0

    self.LookUp = 0
    self.LookRight = 0

    self.LookRightRate = 150
    self.LookUpRate = 150


    -- playAnimation
    self.pitchRate = 2.0
    self.interpSpeed = 6.0

end

function class:tick()

end

function class:lateTick()
    
end