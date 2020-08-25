
local class = class(GA.Network, "ProtoUp")
class.pbc = nil
-- Well, this was not supposed to be a class but rather a independent component
-- in Pbc, but now it's here to keep style aligned with pbc.down.

local upMeta = {
    id = nil,
    pb = nil
}
local sequence = 0
function InscSequence()
    sequence = sequence + 1
    return sequence
end
setmetatable(upMeta, {__call = function(t, msg , request, handle)
    local wrap = {
        content = pbc.Encode(msg , upMeta.pb ),
        request = InscSequence(),
        response = request.request,
    }
    if handle then 
        pbc.RegisterHandle(wrap.request , handle)
    end
    pbc.Send( pbc.EncodeWrap(wrap) , request.type, t.id )
end
})
local function upDelegate(cmd)
    upMeta.id = pbc.Cmd2Id(cmd)
    upMeta.pb = pbc.Cmd2Pb(cmd)
    return upMeta
end 

setmetatable(class, {__index = function(t, cmd)
    return upDelegate(cmd)
end
})