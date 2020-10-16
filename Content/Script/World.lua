
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
    self._registerManager = {}
end
function class:registerLuaManager(key , luaclass)  
    if self[key] then 
        return
    end
    local manager = luaclass.new()
    manager:init()
    self[key] = manager
    table.insert(self._registerManager , manager)
end
function class:registerUManager(key , luaclass)  
    local manager =  self:spawnLuaActor(luaclass, UE4.FVector(0.0, 0.0, 0.0) , UE4.FRotator(0, 0, 0))
    manager:init()
    self[key] = manager
    table.insert(self._registerManager , manager)
end
function class:InitializeWorld(WorldContext)
    self._uWorldContext = WorldContext
    self:registerUManager("MessageManager" , GA.Manager.MessageManager)

    self:registerLuaManager("EventBus" , GA.Event.EventBus)
    self:registerLuaManager("InterfaceBus" , GA.Interface.InterfaceBus)
    self:registerLuaManager("InputManager" , GA.Input.InputManager)
    self:registerLuaManager("Scheduler" , GA.Time.Scheduler)
    self:registerLuaManager("UIManager" , GA.UI.UIManager)

    for key,luaclass in pairs(GA.initManagerList) do 
        self:registerLuaManager(key , luaclass)
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
    for _,manager in pairs(self._registerManager) do 
        if manager.tick then 
            manager:tick(dt)
        end
    end
end
function class:lateTick(dt)
    for _,manager in pairs(self._registerManager) do 
        if manager.lateTick then 
            manager:lateTick(dt)
        end
    end
end

function class:spawnActor(uclass, uLocation , uRotation , params)
    local transform = UE4.FTransform(uRotation:ToQuat(), uLocation)
    return self._uWorldContext:SpawnActor(uclass , transform , params and params.collisionHandle or UEnum.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
end

function class:spawnLuaActor(luaclass, uLocation , uRotation , params)
    local uclass,modulename = luaclass:GetUnluaBind()
    local transform = UE4.FTransform(uRotation:ToQuat(), uLocation)
    return self._uWorldContext:SpawnLuaActor(uclass , transform , params and params.collisionHandle or UEnum.ESpawnActorCollisionHandlingMethod.AlwaysSpawn , self , self, modulename)
end


return class