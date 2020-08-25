

local class = class(GA.Math, "Vector3")
local value = GA.Core.Value
function class:ctor(X ,Y , Z)
    self.X = X or 0.0
    self.Y = Y or 0.0
    self.Z = Z or 0.0
    self.vector = UE4.FVector(self.X, self.Y, self.Z)
end

function class:set(X , Y , Z)
    if X and X ~= self.X then
        self.X = X
    end
    if Y and Y ~= self.Y then
        self.Y = Y
    end
    if Z and Z ~= self.Z then
        self.Z = Z
    end
    self.vector.X = self.X
    self.vector.Y = self.Y
    self.vector.Z = self.Z
end

function class:get()
    return self.vector
end