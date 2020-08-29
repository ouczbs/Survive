
require "UnLua"
local class = Class(GA.Building, "BuildingMaster")

--GameWorld.Building.BuildingMaster
function class:UserConstructionScript()
    -- gWorld.EventBus:registerLuaEvent(gLuaType.AddBuildGrid, self.changeIgnoreActor , self)
    -- gWorld.EventBus:registerLuaEvent(gLuaType.AddBuildPart, self.changeIgnoreActor , self)
    -- gWorld.EventBus:registerLuaEvent(gLuaType.AddFloorMesh, self.changeIgnoreActor , self)

    self:init_ignoreActorArray()
end
-- real time update m_ignoreActorArray 
function class:init_ignoreActorArray()
    local actors = UGameplayStatics.GetAllActorsOfClass(gWorld:getWorldContext() , GA.BpClass.LandScape)
    self.m_ignoreActorArray:Append(actors)
    self:AddIgnoreActor(self.Object)
end
function class:changeIgnoreActor(actor , isRemove)
    if isRemove then 
        self:removeIgnoreActor(actor)
    else  
        self:AddIgnoreActor(actor)
    end
end
function class:removeIgnoreActor(actor)
    if not actor or not self.m_ignoreActorArray then return end
    local array = self.m_ignoreActorArray
    for i = 1, array:Length()  do 
        if array:Get(i) == actor then 
            array:Remove(i)
        end
    end
end

function class:AddIgnoreActor(actor)
    if not actor or not self.m_ignoreActorArray then return end
    local array = self.m_ignoreActorArray
    for i = 1, array:Length()  do 
        if array:Get(i) == actor then return end
    end
    self.m_ignoreActorArray:Add(actor)
end

function class:Lua_AddActorCheck()
    local ignoreArray = self.m_ignoreActorArray
    local rayStart = self:K2_GetActorLocation()
    local rayEnd = rayStart + UE4.FVector(0, 0 , 1000)
    local outHits, boolOut = UKismetSystemLibrary.SphereTraceMulti(gWorld:getWorldContext(),rayStart , rayEnd ,250 , ETraceTypeQuery.Visibility ,false , ignoreArray , EDrawDebugTrace.None , {} , true)
    return boolOut
end

function class:Lua_Collision()
    -- local Build_Type = self["Build Type"]
    -- local type = Build_Type.Type
    -- if type == E_BuildTypes.Blueprint or E_BuildTypes.Decoration then 
    --     if Build_Type["Grid Required"] then
    --         if self["Add Instance Check"]() then 
    --             return E_Preview.Disable
    --         elseif UKismetArrayLibrary.Array_Length(self.SelectedMesh:GetOverlappingActors()) > 0 then 
    --             return E_Preview.Disable
    --         end
    --     end
    -- elseif type == E_BuildTypes.Window or E_BuildTypes.Door then 


    -- elseif self["Get Overlapping Actors"]() then 
    --     return E_Preview.Disable
    -- elseif type == E_BuildTypes.Foundation then
    --     if self["Detect Terrain"]() then 
    --         if self["Foundation Check"]() then 
    --             if self["Grid Hit"] then 

    --             elseif self["Add Actor Check"]() then 
    --                 return E_Preview.Disable
    --             else  

    --             end
    --         else  
    --             return E_Preview.Disable
    --         end
    --     else  
    --         return E_Preview.Disable
    --     end
    -- else  

    -- end
    -- logE("Lua_Collision" , type , E_BuildTypes.Decoration)
end

return class