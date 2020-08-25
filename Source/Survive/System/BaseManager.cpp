// Fill out your copyright notice in the Description page of Project Settings.


#include "BaseManager.h"
#include "MMOGameMode.h"
// Sets default values
ABaseManager::ABaseManager()
	:Super()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = false;

}
ABaseManager::ABaseManager(const FObjectInitializer& ObjectInitializer)
	:Super(ObjectInitializer)
{
}
void ABaseManager::PreInitialize()
{
	// To do implementation
}

void ABaseManager::PostInitializeComponents()
{
	Super::PostInitializeComponents();
}

void ABaseManager::EndPlay(const EEndPlayReason::Type EndPlayReason)
{
	Super::EndPlay(EndPlayReason);
}

// Called when the game starts or when spawned
void ABaseManager::BeginPlay()
{
	Super::BeginPlay();
	
}
void ABaseManager::RegisterToGame()
{

}
