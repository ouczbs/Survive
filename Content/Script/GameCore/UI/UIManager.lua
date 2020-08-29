local class = class(GA.UI, "UIManager")

function class:ctor()
    self.m_UiStack = {}
end

function class:init()
    
end

function class:openUIWindowWithClassName(sClassName, bKeepOther)
    local uiClass = GA.UI[sClassName]
    local layer = uiClass.s_Layer
    if not self.m_UiStack[layer] and layer then 
        self.m_UiStack[layer] = GA.UI.UIStack.new()
    end
	local retUI = self.m_UiStack[layer]:openUIWindowWithClass(uiClass, bKeepOther or false)
    return retUI
end