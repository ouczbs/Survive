import os,re,glob
from utils import *
def AutoGenPbc_Map(cmdList , outFile):
    msgPrefix = "CMD_"
    msgExclude = ["_START", "_END"]
    pattern = re.compile("[a-zA-Z_]+")
    outputList = []
    outputList.append("--This is a cmd desc file auto gen from origin-proto.")
    outputList.append("--Please do no modification.")
    outputList.append("local EProtoMap = {")
    for cmd in cmdList:
        if re.search(msgPrefix, cmd) and \
        not re.search(msgExclude[0], cmd) \
        and not re.search(msgExclude[1], cmd):
            res = pattern.search(cmd)
            if res:
                cmdStr = res.group()
                outputList.append("    {0} = '{1}',".format(cmdStr[4:] ,cmdStr.replace("CMD_" , "pb.")) )

    outputList.append("}")
    outputList.append("return EProtoMap")
    with open(outFile, 'wb') as f:
        f.write("\n".join(outputList).encode())
        
def AutoGenPbc_Id(cmdList , outFile):
    msgPrefix = "Cmd"
    msgExclude = ["_START", "_END"]
    pattern = re.compile("[a-zA-Z0-9_]+")
    outputList = []
    outputList.append("--This is a cmd desc file auto gen from origin-proto.")
    outputList.append("--Please do no modification.")
    outputList.append("local EProtoId = {")
    for cmd in cmdList:
        if re.search(msgPrefix, cmd) and \
        not re.search(msgExclude[0], cmd) \
        and not re.search(msgExclude[1], cmd):
            res = pattern.findall(cmd)
            if res:
                outputList.append("    {0} = {1},".format(res[0][1:] , res[1]) )
    outputList.append("\n\n}")
    outputList.append("return EProtoId")
    with open(outFile, 'wb') as f:
        f.write("\n".join(outputList).encode())
        
def AutoGenPbc_Enum(protoDir ,outFile ):
    protoFNs = glob.glob(os.path.join(protoDir, '*.proto'))
    pattern = re.compile(r"enum *([a-zA-Z0-9_]+)[ \r\n]*{([^}]*)}")
    protoOutLua = []
    protoOutLua.append("--This is a cmd desc file auto gen from origin-proto.")
    protoOutLua.append("--Please do no modification.")
    protoOutLua.append("local EMsgId = {")
    for proto in protoFNs:
        if "Cmd" in proto:
            continue
        protoContent = ""
        with open(proto, 'rb') as f:
            protoContent = f.read().decode()
        enums = pattern.findall(protoContent) or []
        for enum in enums:
            res = "\t" + enum[0] + " = {"
            res += enum[1].replace(";",",").replace("\n","\n\t") + "}"
            protoOutLua.append(res)
    protoOutLua.append("\n\n}")
    outputList.append("return EMsgId")
    with open(outFile, 'wb') as f:
        f.write("\n".join(protoOutLua).encode())
        
def GenAndRegPBC(rootDir):
    # gen pb file.
    os.chdir(rootDir + "/Proto")
    exeDir = rootDir + "/Proto/"
    outPBCDir = rootDir +"/Script/Network/Pb/"
    cmd = "pb2pbc.bat {0} {1}".format(exeDir , outPBCDir)
    popen = os.popen(cmd)
    lines = popen.readlines()
    UPrint(cmd)
    if lines:
        UPrint("".join(lines))
    os.chdir(rootDir)
    # gen pb reg.
    pbcContent = ""
    registerLuaFile = rootDir +"/Script/Network/pbc.lua"
    with open(registerLuaFile, 'rb') as f:
        pbcContent = f.read().decode()
    searchStr = "-- pbc reg auto-gen"
    fIdx = pbcContent.find(searchStr )
    lIdx = pbcContent.rfind(searchStr)
    outAutoGen = ""
    if fIdx != lIdx :
        protoPBs = glob.glob(os.path.join(outPBCDir, '*.pb'))
        pbOutList = []
        pbOutList.append(searchStr)
        for pb in protoPBs:
            (_,pbName) = os.path.split(pb)
            pbOutList.append("    _regFile('{0}')".format(pbName))
        pbOutList.append("\t" + searchStr)
        outAutoGen = pbcContent[:fIdx] + "\n".join(pbOutList) + pbcContent[lIdx + len(searchStr):]
        with open(registerLuaFile, 'wb') as f:
            f.write(outAutoGen.encode())
            
def AutoGenPbc(rootDir):
    inFile = rootDir + "/Proto/Cmd.proto"
    outFile = rootDir +  "/Script/Network/EProtoMap.lua"
    outFile2 = rootDir + "/Script/Network/EProtoId.lua"
    protoDir = rootDir + "/Proto/"
    protoOutLuaFile = rootDir + "/Script/Network/EMsgId.lua"
    cmdList = []
    with open(inFile, 'rb') as f:
        cmdList = [line.decode() for line in f.readlines()]
    UPrint("AutoGenPbc_Map")
    #AutoGenPbc_Map(cmdList , outFile) # gen protoMap.
    UPrint("AutoGenPbc_Id")
    AutoGenPbc_Id(cmdList , outFile2) # gen protoId.
    UPrint("AutoGenPbc_Enum")
    AutoGenPbc_Enum(protoDir ,protoOutLuaFile )# gen all msgEnum
    GenAndRegPBC(rootDir)