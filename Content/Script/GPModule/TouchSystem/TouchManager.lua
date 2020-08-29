
local class = class(GA.Manager, "TouchManager" )


function class:ctor()

end
function class:init()
    local widget = gWorld.UIManager:openUIWindowWithClassName("TouchWindow")
    -- local controller = UGameplayStatics:GetPlayerController(0)
    -- if controller then 
    --     controller:bShowMouseCursor(true)
    -- end
end

GA:AddInitManager(class.__cname , class)

return class