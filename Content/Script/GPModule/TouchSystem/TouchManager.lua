
local class = class(GA.Manager, "TouchManager" )


function class:ctor()

end
function class:init()
    local widget = gWorld.UIManager:openUIWindowWithClassName("TouchWindow")
    -- local controller = UE4.UGameplayStatics:GetPlayerController(0) 
    -- controller:bShowMouseCursor(true)
end

GA:AddInitManager(class.__cname , class)

return class