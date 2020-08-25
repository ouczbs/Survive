// Fill out your copyright notice in the Description page of Project Settings.


#include "MMOGameMode.h"
#include "System/MessageManager.h"
#include "System/LuaManager.h"
#include "LuaWrapper/CppBindingLibs.h"
const char *PBCLIBS_NAME = "protobuf.c";
void AMMOGameMode::InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage)
{
	UE_LOG(LogTemp, Log, TEXT("C++ InitGame"));
	Super::InitGame(MapName, Options, ErrorMessage);
	lua_State * L = UnLua::GetState();
	lua_register(L, "proto_send", proto::_send);
	sInstance = this;
	OverrideInitGame();
}
void AMMOGameMode::StartPlay()
{
	UE_LOG(LogTemp, Log, TEXT("C++ StartPlay"));
	Super::StartPlay();
}

void AMMOGameMode::BeginPlay()
{
	UE_LOG(LogTemp, Log, TEXT("C++ BeginPlay"));
	Super::BeginPlay();
}

void AMMOGameMode::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
	UE_LOG(LogTemp, Log, TEXT("C++ EndPlay"));
	Super::EndPlay(EndPlayReason);
}

void AMMOGameMode::Tick(float DeltaSeconds)
{
	UE_LOG(LogTemp, Log, TEXT("C++ Tick"));
	Super::Tick(DeltaSeconds);
}
void AMMOGameMode::AddManager(UClass* Cls, ABaseManager* manager)
{
	if (ManagerMap.Contains(Cls))
	{
		ManagerMap[Cls] = manager;
		UE_LOG(LogTemp, Log, TEXT("Overide Add Manager"));
	}
	else
	{
		ManagerMap.Add(Cls, manager);
		manager->PreInitialize();
	}
}
void AMMOGameMode::RemoveManager(UClass* Cls, ABaseManager* manager)
{
	if (ManagerMap.Contains(Cls))
	{
		ManagerMap.Remove(Cls);
	}
}
void AMMOGameMode::Respawn(bool inplace)
{
}
AMMOGameMode* AMMOGameMode::sInstance = nullptr;