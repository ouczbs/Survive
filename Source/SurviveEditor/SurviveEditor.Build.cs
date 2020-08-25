// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;

public class SurviveEditor : ModuleRules
{
	public SurviveEditor(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
	
		PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine", "InputCore" });
		PrivateDependencyModuleNames.AddRange(
		new string[]
		{
					"Projects",
					"InputCore",
					"UnrealEd",
					"LevelEditor",
					"CoreUObject",
					"Engine",
					"Slate",
					"SlateCore",
					"EditorStyle",
		}
		);
		PublicIncludePaths.AddRange(new string[] { "SurviveEditor/Public" } );
        PrivateIncludePaths.AddRange(new string[] { "SurviveEditor/Private" } );
	}
}
