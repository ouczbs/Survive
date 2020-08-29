

#pragma once

#include "CoreMinimal.h"
#include "Kismet/BlueprintFunctionLibrary.h"
#include "Materials/MaterialInterface.h"
#include "Materials/MaterialInstanceDynamic.h"
#include "GABlueprintFunctionLibrary.generated.h"

/**
 * class ATELIER_API UGABlueprintFunctionLibrary : public UBlueprintFunctionLibrary
 */
UCLASS()
class SURVIVE_API UGABlueprintFunctionLibrary : public UBlueprintFunctionLibrary
{
	GENERATED_BODY()

public:
	UFUNCTION(BlueprintCallable, Category = "C++ Library")
	static void SwitchMaterialWithParams(class UMaterialInterface* OriginMat, class UMaterialInstanceDynamic* NewMat);

};
