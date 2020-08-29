--lua class : SurviveGameMode
require "UnLua"
print("lua class : SurviveGameMode")
local class = Class(_G,"SurviveGameMode")
function class:Initialize(Initializer)
    print("Initialize GameWorld")
end

function class:UserConstructionScript()
    
end
function class:OverrideInitGame()
    print("OverrideInitGame*******************")
    require "World"
    require "GameGlobal"
    --创建各种message
    local WorldContext = self:GetWorld()
    gWorld:InitializeWorld(WorldContext)
end
function class:ReceiveBeginPlay()
    print("ReceiveBeginPlay GameMode")
    gWorld:beginPlay()
    print(self.Object.Super)
    print(self.Object.Respawn)
    print(self:Respawn(true))
end

--[[
function class:ReceiveEndPlay()
end
--]]

function class:ReceiveTick(DeltaSeconds)
    if gWorld then
        gWorld:tick(DeltaSeconds)
        gWorld:lateTick(DeltaSeconds)
    end
end

--[[
function class:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
end
--]]

--[[
function class:ReceiveActorBeginOverlap(OtherActor)
end
--]]

--[[
function class:ReceiveActorEndOverlap(OtherActor)
end
--]]

return class
