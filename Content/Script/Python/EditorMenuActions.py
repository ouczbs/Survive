from utils import *
import GenPbc,GenLuaRef,GenLuaModule
import argparse
import os,sys 
UPrint("Excute current Action :")
UPrint("cmd:  " , " ".join(sys.argv))
args = argparse.ArgumentParser(description = 'Excute Python Utils ')
args.add_argument("-f",'--function',  type = str, dest = "function",   help = u"执行函数")
args.add_argument("-p", "--parms", dest = "parms",    help = "函数参数",        nargs = '*')
args = args.parse_args()#返回一个命名空间,如果想要使用变量,可用args.attr
def AutoGenPbc(parms):
    if parms and parms[0]:
        UPrint("Genpbc.AutoGenPbc" , parms[0])
        Genpbc.AutoGenPbc(parms[0])
    pass
def AutoGenBlueprintTypeRefForLua(parms):
    if parms and parms[0]:
        UPrint("GenLuaRef.AutoGenBlueprintTypeRefForLua" , parms[0])
        GenLuaRef.AutoGenBlueprintTypeRefForLua(parms[0])
    pass
def AutoGenLuaModule(parms):
    if parms and parms[0]:
        UPrint("GenLuaRef.AutoGenLuaModule" , parms[0])
        GenLuaModule.AutoGenLuaModule(parms[0])
    pass
ExcuteDict = {
    "AutoGenPbc":AutoGenPbc , 
    "AutoGenBlueprintTypeRefForLua":AutoGenBlueprintTypeRefForLua,
    "AutoGenLuaModule":AutoGenLuaModule,
}
UPrint("ExcuteDict" , args.function)
for k in args.parms:
    UPrint("args.parms" , k)
if args.function and ExcuteDict[args.function]:
    try:
        ExcuteDict[args.function](args.parms) 
    except Exception as e:
        UPrint(e)
    os.system("pause")