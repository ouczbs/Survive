#include "EditorMenuActions.h"
const FString tRootDir = FPaths::ProjectContentDir();
const FString tPythonDir = tRootDir + "/Script/Python";
void FEditorMenuActions::OpenMainLevel() {
	const FString MAIN_LEVEL = "Empty";
	//UEditorStaticLibrary::OpenLevelByName(MAIN_LEVEL);
}
void ExcuteAction(FString tCmd) {
#if PLATFORM_WINDOWS
	system(TCHAR_TO_ANSI(*tCmd));
#endif
}
void FEditorMenuActions::AutoGenPbc() {
	const FString tCmd = "python " + tPythonDir + "/EditorMenuActions.py -f AutoGenPbc -p "+ tRootDir ;
	ExcuteAction(tCmd);
}

void FEditorMenuActions::AutoGenBlueprintTypeRefForLua() {
	const FString tCmd = "python " + tPythonDir + "/EditorMenuActions.py -f AutoGenBlueprintTypeRefForLua -p " + tRootDir;
	ExcuteAction(tCmd);
}

void FEditorMenuActions::AutoGenLuaModule() {
	const FString tCmd = "python " + tPythonDir + "/EditorMenuActions.py -f AutoGenLuaModule -p "+ tRootDir ;
	ExcuteAction(tCmd);
}