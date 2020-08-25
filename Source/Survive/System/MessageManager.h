// Fill out your copyright notice in the Description page of Project Settings.

#pragma once
#include <string.h>
#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "NetWork/Message.h"
#include "BaseManager.h"
#include "Singleton.h"
#include "MessageManager.generated.h"

UCLASS()
class SURVIVE_API AMessageManager : public ABaseManager, public ISingleton<AMessageManager>
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AMessageManager();
	UFUNCTION(BlueprintCallable, Category = "C++ API")
	void Connect(const FString& Host);

	UFUNCTION(BlueprintCallable, Category = "C++ API")
	void Disconnect();
	void SendMessage(const std::string& msg , int type ,int id);
	void RegisterToGame();

	UFUNCTION(BlueprintImplementableEvent, Category = "Override C++")
	void OverrideDisconncet();
protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;
	TSharedPtr<Message> message;
public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

};
