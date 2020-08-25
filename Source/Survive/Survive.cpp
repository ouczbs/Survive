// Fill out your copyright notice in the Description page of Project Settings.

#include "Survive.h"
#include "Modules/ModuleManager.h"
IMPLEMENT_PRIMARY_GAME_MODULE(FSurviveModule, Survive, "Survive" );
void FSurviveModule::StartupModule()
{
	FModuleManager::Get().LoadModule(TEXT("SurviveEditor"));
}

void FSurviveModule::ShutdownModule()
{

}