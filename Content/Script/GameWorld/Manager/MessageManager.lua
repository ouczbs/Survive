--lua class : test_C
require "UnLua"
local class = Class(GA.Manager, "MessageManager")

function class:GetUnluaBind()
    return GA.BpClass.BP_MessageManager,"GameWorld.Manager.MessageManager"
end

function class:init()
    self:RegisterToGame()
end
return class

