
require "UnLua"
local class = Class(GA.UI, "TouchWindow" , GA.UI.UIWindow)

class.s_bpWindow = GA.BpClass.UI_TouchWindow
class.s_layer = 10

function class:BuildingMode_Pressed()
    gWorld.InputManager:notifyInput("BuildingMode_Pressed")
end

function class:Interactive_Pressed()
    gWorld.InputManager:notifyInput("Interactive_Pressed")
end

function class:JumpAction_Pressed()
    gWorld.InputManager:notifyInput("JumpAction_Pressed")
end

function class:WalkAction_Pressed()
    gWorld.InputManager:notifyInput("WalkAction_Pressed")
end

function class:StanceAction_Pressed()
    gWorld.InputManager:notifyInput("StanceAction_Pressed")
end

function class:SprintAction_Pressed()
    gWorld.InputManager:notifyInput("SprintAction_Pressed")
end

function class:SprintAction_Released()
    gWorld.InputManager:notifyInput("SprintAction_Released")
end

function class:AimAction_Pressed()
    gWorld.InputManager:notifyInput("AimAction_Pressed")
end

function class:AimAction_Released()
    gWorld.InputManager:notifyInput("AimAction_Released")
end

function class:RollAction_Pressed()
    gWorld.InputManager:notifyInput("RollAction_Pressed")
end

return class