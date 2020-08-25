
local class = class(GA.Math, "Vector2")
local value = GA.Core.Value
function class:ctor(X ,Y)
    self.X = X or 0.0
    self.Y = Y or 0.0
    self.vector = UE4.FVector2D(self.X, self.Y)
end

function class:set(X , Y)
    if X and X ~= self.X then
        self.X = X
    end
    if Y and Y ~= self.Y then
        self.Y = Y
    end
    self.vector.X = self.X
    self.vector.Y = self.Y
end

function class:get()
    return self.vector
end