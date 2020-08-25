// Fill out your copyright notice in the Description page of Project Settings.


#include "MessageManager.h"
#include "Async/Async.h"
// Sets default values
AMessageManager::AMessageManager()
{
 	// Set this actor to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
	PrimaryActorTick.bCanEverTick = false;
}

// Called when the game starts or when spawned
void AMessageManager::BeginPlay()
{
	Super::BeginPlay();
	
}

// Called every frame
void AMessageManager::Tick(float DeltaTime)
{
	Super::Tick(DeltaTime);
}
void AMessageManager::Disconnect()
{
	message->PostDisconnect();
	OverrideDisconncet();
}

void AMessageManager::Connect(const FString& Host)
{
	UE_LOG(LogTemp, Display, TEXT("Connect To Host [%s]."), *Host);
	message = MakeShareable(new Message(std::string(TCHAR_TO_UTF8(*Host))));
	message->OnLuaRcvPbcMsg = [this](const std::string& content, int16 type , int16 id) {
		AsyncTask(ENamedThreads::GameThread, [content , type ,id]() {
			lua_State * L = UnLua::GetState();
			UE_LOG(LogTemp, Display, TEXT("Test Connect, binary length [%i]."),  content.length());
			UE_LOG(LogTemp, Display, TEXT("Test Connect, binary stream [%s]."), *FString(content.c_str()));
			if (L) {
				lua_getglobal(L, "Pbc");
				lua_getfield(L, -1, "rcv");
				lua_pushlstring(L, content.c_str(), content.size());
				lua_pushnumber(L, type);
				lua_pushnumber(L, id);
				if (lua_pcall(L, 3, 0, 0) != 0)
				{
					UE_LOG(LogTemp, Warning, TEXT("Error while executing pbc: %s"), *FString(lua_tostring(L, -1)));
					lua_settop(L, 0);
					return;
				}
				lua_settop(L, 0);
			}
		});
	};
	message->PostConnect();
}
void AMessageManager::SendMessage(const std::string& msg , int type , int id) {
	//UE_LOG(LogTemp, Log, msg);
	message->SendPbcMessage(msg ,type ,id );
}
void AMessageManager::RegisterToGame()
{
	AMMOGameMode::GetGameWorld()->AddManager(AMessageManager::StaticClass() , this );
}