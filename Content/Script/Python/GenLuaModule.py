import os
import re
module_dir_list = ["GameCore" , "GameManager" , "GamePlay"  ,"GameWorld", "GPModule" ,"GWModule" ]
module_file_list = ["GC.lua" , "GM.lua" , "GP.lua"  ,"GW.lua" ,"GPM.lua" ,"GWM.lua"]
def CheckFileRequire(module_file , require_list):
    require_dict = {}
    write_lines = [""]
    with open(module_file , "r") as f:
        lines = [line for line in f.readlines() if "require" in line]
    for line in lines:
        res = re.search('require +"([_A-Za-z0-9\.]+)"' , line)
        if res:require_dict[res.group(1)] = True
    for require in require_list:
        if require not in require_dict:
            write_lines.append('require "{0}"'.format(require))
    if len(write_lines) == 1 :return
    with open(module_file , "a+") as f:
        f.write("\n".join(write_lines))
def CheckRequire(root_dir , module_file , require_name , module_name):
    require_list = []
    dir_list = []
    module_path = "{0}\\{1}".format(root_dir, module_file)
    for fi in os.listdir(root_dir):
        if os.path.isdir(root_dir + "\\" + fi):
            dir_list.append(fi)
            require_list.append("{0}.{1}.{1}_Module".format(require_name , fi))
        elif "_Module" not in fi and fi != module_file:
            require_list.append("{0}.{1}".format(require_name , fi[:-4]))
    if not os.path.exists(module_path):
        with open(module_path , "w+") as f:
            lines = "\n%s or {}\n\n"% ( "{0} = {0}".format(module_name ) )
            if module_name == "GA" and module_file != module_name:
                lines = "\n\n"
            f.write(lines)
    CheckFileRequire(module_path , require_list)
    if require_name == "GPModule" or require_name == "GWModule":
        for fi in dir_list:
            CheckRequire("{0}\\{1}".format(root_dir, fi),"{0}_Module.lua".format(fi) , "{0}.{1}".format(require_name, fi) , module_name)
        return
    for fi in dir_list:
        CheckRequire("{0}\\{1}".format(root_dir, fi),"{0}_Module.lua".format(fi) , "{0}.{1}".format(require_name, fi) , "{0}.{1}".format(module_name, fi))
def AutoGenLuaModule(root_dir):
    for module_dir,module_file in zip(module_dir_list,module_file_list):
        CheckRequire(root_dir + "Script\\" + module_dir , module_file , module_dir , "GA")