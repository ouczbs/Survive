local class = class(GA.UI, "UIStack")

function class:ctor(layer)
	self.m_UIBaseArray	   = {}
	self.layer = layer
end
local function _findUIWindow(windowArray , uiClass)
	for index ,window in ipairs(windowArray) do 
		if window.__cname == uiClass.__cname then 
			return window , index
		end
	end
end
function class:openUIWindowWithClass(uiClass, inIsKeepOther)
	local tWindow , tIndex = _findUIWindow(self.m_UIBaseArray , uiClass )
	if tWindow == nil then
		tWindow = UWidgetBlueprintLibrary.Create(gWorld:getWorldContext() , uiClass.s_bpWindow)
		tWindow:AddToViewport()
		tWindow:init()
	end
	return self:openUIInternal(tWindow, inIsKeepOther, tIndex)
end

function class:openUIInternal(inWindow, inIsKeepOther, inInternalIndex)
	local tIsLast = inInternalIndex == #self.m_UIBaseArray
	if tIsLast then 
		self:showWindow(inWindow)
		return inWindow
	end
	table.remove(self.m_UIBaseArray, inInternalIndex)
	local tCurrentUICount = #self.m_UIBaseArray
	if inWindow.s_bClearSelfStack then
		self:clearUIWindows()
	elseif tCurrentUICount ~= 0 and not inIsKeepOther then
		self:hideUIWindow(self.m_UIBaseArray[tCurrentUICount])
	end
	table.insert(self.m_UIBaseArray, inWindow)
	self:showWindow(inWindow)
	return inWindow
end

function class:showWindow(window)
	window:show()
end

function class:clearUIWindows()
	for _,window in ipairs(self.m_UIBaseArray) do 
		window:destroy()
	end 
	self.m_UIBaseArray = {}
end
function class:hideUIWindow(window)
	window:hide()
end