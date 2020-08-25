// Fill out your copyright notice in the Description page of Project Settings.

using UnrealBuildTool;
using System.Collections.Generic;

public class SurviveTarget : TargetRules
{
	public SurviveTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Game;

		ExtraModuleNames.AddRange( new string[] { "Survive" } );
		//ExtraModuleNames.AddRange( new string[] { "SurviveEditor" });
	}
}
