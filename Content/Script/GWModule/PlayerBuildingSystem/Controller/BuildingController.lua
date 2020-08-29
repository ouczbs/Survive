
local class = Class(GA.Controller ,"BuildingController")

function class:Initialize(Initializer)
    print("Initialize BuildingController")
end
function class:ReceiveEndPlay()
    print("ReceiveEndPlay BuildingController")
end
return class