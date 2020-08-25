
local class = class(GA.Network, "ProtoDown")

class.ServerTimeUserCmd = function(msg)
    gWorld.NetworkMonitor:updateTime(msg.time)
end
