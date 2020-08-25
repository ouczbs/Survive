// Fill out your copyright notice in the Description page of Project Settings.


#include "LuaManager.h"

// Sets default values
ALuaManager::ALuaManager()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void ALuaManager::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void ALuaManager::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);

}

