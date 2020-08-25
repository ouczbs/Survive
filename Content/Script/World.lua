if WITH_LUAIDE_DEBUG then
    require("socket.core")
    require("LuaPanda").start("127.0.0.1",8818)
end
require "GameCore.GC"
require "GamePlay.GP"
require "GameManager.GM"
require "GameWorld.GW"
require "GameConfig.Config_Module"
require "Network.Network_Module"

local class = class(GA,"World")
pbc = GA.Network.Pbc.new()
function class:ctor()  
    self._uWorldContext = nil
end

function class:InitializeWorld(WorldContext)
    self._uWorldContext = WorldContext
    self.MessageManager = self:SpawnActorByLua(GA.Manager.MessageManager, UE4.FVector(0.0, 0.0, 0.0) , UE4.FRotator(0, 0, 0))
    self.MessageManager:init()
    self.MessageManager:Connect(GameConfig.Host);
    local account = GA.Login.Account.new()
    account.account = "name"
    account.password = "psd"
    account:LoginAccountCmd()
    --self.MessageManager:SendMessage("sad");
end
function class:getWorldContext()
    return self._uWorldContext
end
function class:setWorld(world)
    self.world = world
end
function class:setGameWorld(GameWorld)
    self.GameWorld = GameWorld
end
function class:beginPlay()
    --local zero = UE4.FVector(0.0, 0.0, 0.0)
    --self.inputManage = GA.Manage.InputManage.new()

    -- local playerControl = UE4.UGameplayStatics.GetPlayerController(self.world, 0)
    -- self.playerNet = GA.Player.PlayerNet.new(playerControl)
    -- self.message_beginPlay:send()
end

-- function class:initializeWorld()
--     -- self.eventBus               = GA.Core.EventBus.new()
--     -- self.StateManager           = GA.Core.StateManager.new()
--     -- self.scheduler              = GA.Core.Scheduler.new()
--     -- self.UserInput              = GA.Input.UserInput.new()
--     -- self.NetworkMonitor         = GA.Network.NetworkMonitor.new()
--     -- self.playerInputManager     = GA.Core.PlayerInputManager.new(self.UserInput)
--     -- self.playerController       = GA.Core.PlayerController.new()
-- end

function class:tick(dt)
    if self.playerNet then self.playerNet:tick(dt) end
end
function class:lateTick(dt)
    if self.playerNet then self.playerNet:lateTick(dt) end
end
function class:SpawnActorByLua(luaclass, uLocation , uRotation , params)
    local uclass,modulename = luaclass:GetUnluaBind()
    local transform = UE4.FTransform(uRotation:ToQuat(), uLocation)
    return self._uWorldContext:SpawnActor(uclass , transform , params and params.collisionHandle or ESpawnActorCollisionHandlingMethod.AlwaysSpawn , self , self, modulename)
end
return class