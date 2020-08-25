// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "BaseManager.generated.h"

UCLASS()
class SURVIVE_API ABaseManager : public AActor
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ABaseManager();
	ABaseManager(const FObjectInitializer& ObjectInitializer);

	// Called when the game starts or when spawned
	virtual void PreInitialize();
	virtual void PostInitializeComponents();
	virtual void EndPlay(const EEndPlayReason::Type EndPlayReason);
	virtual void BeginPlay() override;
	UFUNCTION(BlueprintCallable, Category = "C++ API")
	virtual void RegisterToGame();
};
