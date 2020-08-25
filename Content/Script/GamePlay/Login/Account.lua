
local class = class(GA.Login, "Account")

function class:LoginAccountCmd()
    local msg = {
        account = self.account,
        password = self.password
    }
    gRequest.request = nil 
    gRequest.type = gRefers.MT.GameLogin
    logE(Pbc , pbc.up , pbc.Send)
    pbc.up.LoginAccountCmd(msg , gRequest , self.LoginAccountCmdAck)
end

function class:LoginAccountCmdAck(msg,request)
    logE(msg , request ,"LoginAccountCmdAck")
end