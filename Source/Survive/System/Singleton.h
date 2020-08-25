#pragma once
#include "CoreMinimal.h"
#include "MMOGameMode.h"

template<typename T>
class ISingleton
{
public:
	UFUNCTION(BlueprintCallable, Category = "C++ API")
	static T* I()
	{
		static T* sInstance = nullptr;
		// 防止持有野指针
		sInstance = AMMOGameMode::SeekManagerInstance<T>();
		return sInstance;
	}

	static bool CheckValid()
	{
		return I() != nullptr;
	}
};
