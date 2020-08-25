from utils import *
import os
output_List = []
output_List_BpClass = []
def parseBPFile(file_dir, file_name):
    if file_name.endswith("BP.uasset") or (file_name.startswith("BP_") and ".uasset" in file_name):
        file_name = file_name.replace(".uasset" , "")
        output_List.append("\t{0} = '{1}/{0}' ,".format(file_name , file_dir ))
        output_List_BpClass.append("\t{0} = BpType.{0} ,".format(file_name ))
        pass  
def parseFiles(root_dir , rel_dir  , callback = parseBPFile):
    output_List.append("\t-- {0} start".format(root_dir))
    output_List_BpClass.append("\t-- {0} start".format(root_dir))
    for parent,dir_names,file_names in os.walk(root_dir):
        rel_parent = parent.replace(rel_dir,"/Game")
        rel_parent = rel_parent.replace("\\","/")
        for file_name in file_names:
            callback(rel_parent, file_name)
    output_List.append("\t-- {0} end\n".format(root_dir))
    output_List_BpClass.append("\t-- {0} end\n".format(root_dir))
def AutoGenBlueprintTypeRefForLua(root_dir):
    UPrint("excute ", root_dir, "AutoGenBlueprintTypeRefForLua")
    out_file = root_dir + "/Script/GamePlay/Gen/BlueprintTypeGen.lua";
    out_file2 = root_dir + "/Script/GamePlay/Gen/BpClass.lua";
    output_List.append("local BpType = {")
    s_bp = "Blueprints"
    parseFiles(root_dir + "\\" + s_bp , root_dir, parseBPFile)
    for fi in os.listdir(root_dir):
        bp_dir = root_dir + "\\" + fi + "\\" + s_bp
        if os.path.exists(bp_dir):
            parseFiles(bp_dir , root_dir, parseBPFile)
    output_List.append("}")
    output_List.append("GA.BpType = BpType")
    with open(out_file, 'wb') as f:
        f.write("\n".join(output_List).encode())
    context = None
    with open(out_file2, 'rb') as f:
        context = RePlaceRegions(f.read() , b"-- bpmap reg auto-gen" ,"\n".join(output_List_BpClass).encode() )
    with open(out_file2, 'wb') as f:
        f.write(context)