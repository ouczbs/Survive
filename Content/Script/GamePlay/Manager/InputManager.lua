
local class = class(GA.Manager, "InputManager" )

function class:ctor()
    self.axis = {}
    self.button = {}
    self:Initialize()
end

function class:clearAll()
    self.axis = {}
    self.button = {}
end

function class:clearAxis()
    for k,v in pairs(self.axis) do 
        v.clear()
    end
    self.axis = {}
end

function class:clearButton()
    for k,v in pairs(self.button) do 
        v.clear()
    end
    self.button = {}
end

function class:Initialize()
    self:addButton("Run")
    self:addButton("Jump")
    self:addButton("Attack")
    self:addButton("Relod")
    self:addButton("Crouch")

    self:addAxis("Move X")
    self:addAxis("Move Y")
    self:addAxis("Turn X")
    self:addAxis("Turn Y")
end

function class:addButton(name)
    local button = self.button[name]
    if button then
        return button
    end
    button = GA.Input.Button.new()
    self.button[name] = button
    return button
end

function class:removeButton(name)
    local button = self.button[name]
    if button then
        self.button[name] = nil
    end
end

function class:addAxis(name)
    local axis = self.axis[name]
    if axis then
        return axis
    end
    axis = GA.Input.Axis.new()
    self.axis[name] = axis
    return axis
end

function class:removeAxis(name)
    local axis = self.axis[name]
    if axis then
        self.axis[name] = nil
    end
end

function class:getButton(name)
    return self.button[name]
end

function class:getAxis(name)
    return self.axis[name]
end

function class:getButtonVar(name)
    return self.button[name]:get()
end

function class:getAxisVar(name)
    return self.axis[name]:get()
end