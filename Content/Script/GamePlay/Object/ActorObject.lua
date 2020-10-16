
local class = class(GA.Object, "ActorObject")

function class:ctor(uclass , uLocation , uRotation , params)
    gWorld:spawnActor(uclass , uLocation , uRotation , params)
end