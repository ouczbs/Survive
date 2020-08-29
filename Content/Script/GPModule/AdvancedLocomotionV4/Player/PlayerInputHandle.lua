local class = class(GA.Player, "PlayerInputHandle")

function class:ctor()
    self.RightAxisValue = 0
    self.ForwardAxisValue = 0
    self.LookUp = 0
    self.LookRight = 0

    self.fire = GA.Core.Activity.new(false)
    self.LookRightRate = 150
    self.LookUpRate = 150

    self.moveStop = GA.Core.Activity.new(false)
    self.CrouchAction = GA.Core.Activity.new(false)
    self.JumpAction = GA.Core.Activity.new(false)
    self.SprintAction = GA.Core.Activity.new(false)
end

function class:tick()

end

function class:lateTick()
    
end