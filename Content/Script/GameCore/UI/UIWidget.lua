local class = class(GA.UI, "UIWidget")

function class:ctor()

end

function class:loadBpUI(bpclass)
    return UE4.UWidgetBlueprintLibrary.Create(gWorld:getWorldContext(), bpclass)
end