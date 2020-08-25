--lua class : SurviveGameMode
require "UnLua"
print("lua class : VfX_test")
local class = Class(_G,"VfX_test")
class.proceed = 0
class.loop = 1
class.state = 0
function class:Initialize(Initializer)
    print("Initialize VfX_test")
end
function class:ReceiveBeginPlay()
    local mat= self.StaticMesh:getMaterial(0) 
    self.originMaterial = UKismetMaterialLibrary.CreateDynamicMaterialInstance(gWorld:getWorldContext(), mat, "")
    UGABlueprintFunctionLibrary.SwitchMaterialWithParams(mat, self.originMaterial)
    self.StaticMesh:setMaterial(0, self.originMaterial)
    self:setVFXParams()
end

function class:setVFXParams()
    self.originMaterial:SetScalarParameterValue("Materialize Amount" , 0.2) -- 进度条 0-1
    self.originMaterial:SetScalarParameterValue("MaxHeightOfModel" , 200) -- 模型高度 进度条设0.99 再手动调高度
    self.originMaterial:SetScalarParameterValue("FringeDisplacement" , 1) -- 外凸距离
end
function class:setVFXAmountParam(proceed)
    self.originMaterial:SetScalarParameterValue("Materialize Amount" , proceed) -- 进度条 0-1
end
function class:checkForAmount(dt)
    self.proceed = self.proceed + dt / self.loop
    if self.proceed > 1 then 
        self.proceed = 1
        if class.state == 0 then 
            class.state = -1
        end
        class.state = 1
    end
    if self.proceed < 0 then 
        self.proceed = 0
        class.state = 0
    end
   self:setVFXAmountParam(self.proceed)
end
--[[
function class:ReceiveEndPlay()
end
--]]

function class:ReceiveTick(dt)
    if class.state == 0 then
        self:checkForAmount(dt)
    else  
        self:checkForAmount(-dt)
    end
end

return class
