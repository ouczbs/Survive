if WITH_LUAIDE_DEBUG then
    require("socket.core")
    require("LuaPanda").start("127.0.0.1",8818)
end
require "GameCore.GC"

require "GamePlay.GP"
require "GPModule.GPM"

require "GameManager.GM"

require "GameWorld.GW"
require "GWModule.GWM"

require "Network.Network_Module"

local class = class(GA,"World")

function class:ctor()  
    self._uWorldContext = nil
end

function class:InitializeWorld(WorldContext)
    self._uWorldContext = WorldContext
    self.MessageManager = self:SpawnActorByLua(GA.Manager.MessageManager, UE4.FVector(0.0, 0.0, 0.0) , UE4.FRotator(0, 0, 0))
    self.MessageManager:init()
    self.EventBus = GA.Event.EventBus.new()
    self.EventBus:init()
    self.InterfaceBus = GA.Interface.InterfaceBus.new()
    self.InterfaceBus:init()
    self.UIManager = GA.UI.UIManager.new()
    self.UIManager:init()
    
    for key,UManager in pairs(GA.initManagerList) do 
        print(key ,UManager )
        self[key] = UManager.new()
        self[key]:init()
    end
    GA.initManagerList = nil
    -- self.MessageManager:Connect(GameConfig.Host);
    -- local account = GA.Login.Account.new()
    -- account.account = "name"
    -- account.password = "psd"
    -- account:LoginAccountCmd()
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