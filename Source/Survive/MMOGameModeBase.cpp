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
	 * ����ʱ�����⣬�������������lua���п���PlayerController�Ѿ����ͷ�
	 * �ᵼ��lua����ʱ��Ұָ������
	 * ��������lua������������ص������
	 */
	 //����Lua
	UE_LOG(LogTemp, Log, TEXT("C++ EndPlay"));
	Super::EndPlay(EndPlayReason);
}

void AMMOGameModeBase::Tick(float DeltaSeconds)
{
	UE_LOG(LogTemp, Log, TEXT("C++ Tick"));
	Super::Tick(DeltaSeconds);
}
AMMOGameModeBase* AMMOGameModeBase::sInstance = nullptr;