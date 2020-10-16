--预定义层级，UIBase子类需要通过s_layer变量指定自身层级
GA.UI.Layers = {
    Widgets3D           = 1,        --血量条，任务图标，对话气泡（在BPUICommon设置了ZOrder，重构时记得写在Lua里）
    Main                = 2, 	    --主界面，menumain专用
    Tier1 	            = 3, 	    --功能一级界面
    TeamInfoWindow      = 4,        --编队界面
    Dialog 	            = 5,        --对话界面
    Tier2 	            = 6,        --功能二级界面
    Msg                 = 7,        --弹出框
    Reserved            = 8,        --保留层
    CameraBlend         = 9,        --摄像机融合切换
    Loading             = 10,        --Loading层
    Top                 = 11,       --最上层
    Debug               = 12, 	    --Debug类界面专用
}