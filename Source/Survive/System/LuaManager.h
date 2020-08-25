// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "BaseManager.h"
#include "Singleton.h"
#include "LuaManager.generated.h"

UCLASS()
class SURVIVE_API ALuaManager : public ABaseManager, public ISingleton<ALuaManager>
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	ALuaManager();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

};
