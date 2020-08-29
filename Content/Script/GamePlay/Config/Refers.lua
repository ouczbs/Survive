

GA.Config.Refers = GA.Config.Refers or {}
local Refers = {
    
}
table.append(GA.Config.Refers, Refers)
--------------------------------------------------------------------------------
-- 协议里的枚举类型
--------------------------------------------------------------------------------
local EMsgId = require "Network.EMsgId"
table.append(GA.Config.Refers, EMsgId)