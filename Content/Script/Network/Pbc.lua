
require "Network.ProtoDown"
require "Network.ProtoUp"
local ProtoId = require "Network.EProtoId"
local _pb     = require "pb"
local reversedProtoId = {}
local pb_path = "E:\\ouczbs\\Survive\\Content" .. "\\Script\\Network\\pb\\"
local class = class(GA.Network, "Pbc")
local ProtoPb = {}
local ProtoMap = {}
local Promise = GA.Utility.Promise
local _wrapType = "pb.WrapMessage" 
function class:ctor()
    self.reg()
    self.down = GA.Network.ProtoDown.new()
    self.up = GA.Network.ProtoUp.new()
    for k,v in pairs(ProtoId) do 
        reversedProtoId[v] = k
    end
end
local function _regFile(file)
    _pb.loadfile(pb_path.. file)
end

function class.reg()
    -- pbc reg auto-gen
    _regFile('Cmd.pb')
    _regFile('Login.pb')
    _regFile('MessageType.pb')
    _regFile('Wrap.pb')
	-- pbc reg auto-gen
end
function class.RegisterHandle(sequence , handle)
    ProtoMap[sequence] = handle
end
function class.Send(...)
    proto_send(...)
end
function class.rcvWrapper(data , type , id)
    local cmd = class.Id2Cmd(id)
    local messageType = class.Cmd2Pb(cmd)
    local wrap = _pb.decode(_wrapType , data)
    local msg = _pb.decode(messageType , wrap.content)
    gRequest.request = wrap.request
    gRequest.next = true
    local globalHandle = pbc.down[cmd]
    local response = wrap.response
    local handle = ProtoMap[response]
    ProtoMap[response] = nil
    Promise.Then(handle , gRequest , msg).Then(globalHandle , gRequest , msg)
end 
function class.rcv(data , type , id)
    local status, err = pcall(function() class.rcvWrapper( data, type ,id) end)
    if not status then
        logE(err)
    end
end

function class.Cmd2Id(cmd)
    return ProtoId[cmd]
end

function class.Cmd2Pb(cmd)
    local pb = ProtoPb[cmd]
    if not pb and cmd then 
         pb = "pb." .. cmd
         ProtoPb[cmd] = pb
    end 
    return pb
end

function class.Id2Cmd(id)
    return reversedProtoId[id]
end 

function class.Encode(msg , pb)
    return _pb.encode(pb , msg)
end 
function class.EncodeWrap(wrap)
    return _pb.encode(_wrapType , wrap)
end 


