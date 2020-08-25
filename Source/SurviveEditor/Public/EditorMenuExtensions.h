#pragma once

class FEditorMenuExtensions
{
public:
	static void ExtendMenus();
	static void ExtendToolbars();
	static void ExtendContexMenu();
	static void ExtendContentBrowserContextMenu();

	static void CreateToolbarEntries(FToolBarBuilder& ToolbarBuilder);
	static TSharedRef< SWidget > GenerateMenuContent();
};

struct FInteractiveReadTableInfo
{
	
public:
		int32 id;
		FString tableName;
		FString resourcePath;
		FString model;
		FString interactiveType;
};
