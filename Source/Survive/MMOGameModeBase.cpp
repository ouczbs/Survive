// Fill out your copyright notice in the Description page of Project Settings.


#include "MMOGameModeBase.h"
void AMMOGameModeBase::Respawn(bool inplace)
{
}
void AMMOGameModeBase::InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage)
{
	UE_LOG(LogTemp, Log, TEXT("C++ InitGame"));
	Super::InitGame(MapName, Options, ErrorMessage);
	sInstance = this;
}
void AMMOGameModeBase::StartPlay()
{
	UE_LOG(LogTemp, Log, TEXT("C++ StartPlay"));
	Super::StartPlay();
}

void AMMOGameModeBase::BeginPlay()
{
	UE_LOG(LogTemp, Log, TEXT("C++ BeginPlay"));
	Super::BeginPlay();
}

void AMMOGameModeBase::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
	/**
	 * 由于时序问题，如果在这里清理lua，有可能PlayerController已经被释放
	 * 会导致lua清理时的野指针问题
	 * 所以现在lua清理放在两个回调里完成
	 */
	 //清理Lua
	UE_LOG(LogTemp, Log, TEXT("C++ EndPlay"));
	Super::EndPlay(EndPlayReason);
}

void AMMOGameModeBase::Tick(float DeltaSeconds)
{
	UE_LOG(LogTemp, Log, TEXT("C++ Tick"));
	Super::Tick(DeltaSeconds);
}
AMMOGameModeBase* AMMOGameModeBase::sInstance = nullptr;