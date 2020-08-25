// Copyright

#include "EditorMenuExtensions.h"
#include "LevelEditor.h"
#include "ModuleManager.h"
#include "EditorStyle.h"
#include "Editor.h"
#include "MultiBoxExtender.h"
#include "FileHelpers.h"
#include "SlateDelegates.h"
#include "SharedPointer.h"
#include "EditorMenuActions.h"
FLevelEditorModule::FLevelViewportMenuExtender_SelectedActors LevelEditorMenuExtenderDelegate;

TSharedRef< SWidget > FEditorMenuExtensions::GenerateMenuContent()
{
	const bool bShouldCloseWindowAfterMenuSelection = true;
	FMenuBuilder MenuBuilder(bShouldCloseWindowAfterMenuSelection, nullptr);
	{
		MenuBuilder.AddMenuEntry(
			FText::FromString("Open Main Level"),
			FText::FromString("Open Main Level"),
			FSlateIcon(),
			FUIAction(FExecuteAction::CreateStatic(&FEditorMenuActions::OpenMainLevel)),
			NAME_None,
			EUserInterfaceActionType::Button
		);
	}
	{
		MenuBuilder.BeginSection("Lua Tools", FText::FromString("Lua Tools"));
		MenuBuilder.AddMenuEntry(
			FText::FromString("Gen Blueprint Type"),
			FText::FromString("Gen Blueprint Type"),
			FSlateIcon(),
			FUIAction(FExecuteAction::CreateStatic(&FEditorMenuActions::AutoGenBlueprintTypeRefForLua)),
			NAME_None,
			EUserInterfaceActionType::Button
		);
		MenuBuilder.AddMenuEntry(
			FText::FromString("Gen Pbc"),
			FText::FromString("Gen Pbc"),
			FSlateIcon(),
			FUIAction(FExecuteAction::CreateStatic(&FEditorMenuActions::AutoGenPbc)),
			NAME_None,
			EUserInterfaceActionType::Button
		);
		MenuBuilder.AddMenuEntry(
			FText::FromString("Gen LuaModule"),
			FText::FromString("Gen LuaModule"),
			FSlateIcon(),
			FUIAction(FExecuteAction::CreateStatic(&FEditorMenuActions::AutoGenLuaModule)),
			NAME_None,
			EUserInterfaceActionType::Button
		);
		MenuBuilder.EndSection();
	}
	return MenuBuilder.MakeWidget();
}
void FEditorMenuExtensions::CreateToolbarEntries(FToolBarBuilder& ToolbarBuilder)
{
	ToolbarBuilder.BeginSection("Survive");
	{
		ToolbarBuilder.AddComboButton(
			FUIAction(),
			FOnGetContent::CreateStatic(&FEditorMenuExtensions::GenerateMenuContent),
			FText::FromString("Survive Tools"),
			FText::FromString("List Of Survive Tools"),
			FSlateIcon()
		);
	}
	ToolbarBuilder.EndSection();
}

void FEditorMenuExtensions::ExtendMenus()
{
	
}

void FEditorMenuExtensions::ExtendToolbars()
{
	FLevelEditorModule& LevelEditorModule = FModuleManager::Get().LoadModuleChecked<FLevelEditorModule>("LevelEditor");
	TSharedRef<FExtender> Extender(new FExtender());
	Extender->AddToolBarExtension(
		TEXT("Game"),
		EExtensionHook::After,
		nullptr,
		FToolBarExtensionDelegate::CreateStatic(&FEditorMenuExtensions::CreateToolbarEntries)
	);
	LevelEditorModule.GetToolBarExtensibilityManager()->AddExtender(Extender);
}

void FEditorMenuExtensions::ExtendContexMenu()
{
	
}

void FEditorMenuExtensions::ExtendContentBrowserContextMenu()
{
	
}
