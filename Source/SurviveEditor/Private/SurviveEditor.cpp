// Coypright

#include "SurviveEditor.h"
#include "EditorMenuExtensions.h"
void FSurviveEditorModule::StartupModule()
{
	if (!GIsEditor)
		return;
	FEditorMenuExtensions::ExtendToolbars();
	FEditorMenuExtensions::ExtendContexMenu();
	FEditorMenuExtensions::ExtendContentBrowserContextMenu();
}

void FSurviveEditorModule::ShutdownModule()
{

}

IMPLEMENT_GAME_MODULE(FSurviveEditorModule, SurviveEditor);