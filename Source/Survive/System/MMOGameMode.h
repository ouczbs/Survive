// Fill out your copyright notice in the Description page of Project Settings.

#pragma once
#include "CoreMinimal.h"
#include "GameFramework/GameModeBase.h"
#include "System/BaseManager.h"
#include "Unlua.h"
#include "MMOGameMode.generated.h"

/**
 * 
 */
UCLASS()
class SURVIVE_API AMMOGameMode : public AGameModeBase
{
	GENERATED_BODY()
public:
	virtual void InitGame(const FString& MapName, const FString& Options, FString& ErrorMessage) override;
	UFUNCTION(BlueprintImplementableEvent, Category = "Override C++")
	void OverrideInitGame();
	virtual void StartPlay() override;

	virtual void BeginPlay() override;

	virtual void EndPlay(const EEndPlayReason::Type EndPlayReason) override;

	virtual void Tick(float DeltaSeconds) override;

	UFUNCTION(BlueprintCallable, Category = "C++ API")
	void Respawn(bool inplace);

	template<typename T> static T* SeekManagerInstance()
	{
		if (sInstance && sInstance->ManagerMap.Contains(T::StaticClass()))
		{
			return Cast<T>(sInstance->ManagerMap.FindRef(T::StaticClass()));
		}
		return nullptr;
	}
	static AMMOGameMode* GetGameWorld() {
		return sInstance;
	}
	UFUNCTION(BlueprintCallable, Category = "C++ API")
	void AddManager(UClass* Cls , ABaseManager* manager);
	UFUNCTION(BlueprintCallable, Category = "C++ API")
	void RemoveManager(UClass* Cls, ABaseManager* manager);

private:
	TMap<UClass*, ABaseManager*> ManagerMap;
	static AMMOGameMode* sInstance;
};
