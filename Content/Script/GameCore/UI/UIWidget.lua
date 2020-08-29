local class = class(GA.UI, "UIWidget")

function class:ctor()

end

function class:loadBpUI(bpclass)
    return UWidgetBlueprintLibrary.Create(gWorld:getWorldContext(), bpclass)
end