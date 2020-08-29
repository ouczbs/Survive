// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;

public class Survive : ModuleRules
{
	public Survive(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
	
		PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine", "InputCore" ,"ApexDestruction" ,});

        PublicDependencyModuleNames.AddRange(new string[] { "Unlua" , "Lua" });
		PrivateDependencyModuleNames.AddRange(new string[] {  });
		// avoid winsock.h and winsock2.h conflicts
		PublicDefinitions.Add("ASIO_STANDALONE");
		PublicDefinitions.Add("ASIO_NO_TYPEID");
		PublicDefinitions.Add("ASIO_NO_EXCEPTIONS");
        PrivateIncludePaths.Add("../ThirdParty/Asio/include/");
        // Uncomment if you are using Slate UI
        // PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });

        // Uncomment if you are using online features
        // PrivateDependencyModuleNames.Add("OnlineSubsystem");

        // To include OnlineSubsystemSteam, add it to the plugins section in your uproject file with the Enabled attribute set to true
    }
}
