// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;

public class LuaProtobuf : ModuleRules
{
	public LuaProtobuf(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

		PublicDependencyModuleNames.AddRange(new string[] { "Core" });

		PrivateDependencyModuleNames.AddRange(new string[] { "Lua" });

        ShadowVariableWarningLevel = WarningLevel.Warning;

        PrivateIncludePaths.AddRange(
            new string[] {
                 "ThirdParty/LuaProtobuf/Public",
                 "ThirdParty/LuaProtobuf/Private",
            }
            );
	}
}
