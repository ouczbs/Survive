

local class = class(GA.Player, "WeaponEventHandle")

function class:ctor()
    self.fire = GA.Core.Activity.new(false)
    
end
