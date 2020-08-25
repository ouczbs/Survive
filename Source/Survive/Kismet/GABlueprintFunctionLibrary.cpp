// Fill out your copyright notice in the Description page of Project Settings.


#include "GABlueprintFunctionLibrary.h"


void UGABlueprintFunctionLibrary::SwitchMaterialWithParams(UMaterialInterface* OriginMaterial, UMaterialInstanceDynamic* NewMaterial)
{
	TArray<FMaterialParameterInfo> OutParameterInfo;
	TArray<FGuid> OutParameterIds;
	UMaterialInterface* originMaterial = OriginMaterial;
	UMaterialInstanceDynamic* newMaterial = NewMaterial;

	originMaterial->GetAllScalarParameterInfo(OutParameterInfo, OutParameterIds);
	for (FMaterialParameterInfo SPInfo : OutParameterInfo)
	{
		float Value;
		bool ret = originMaterial->GetScalarParameterValue(SPInfo, Value);
		if (ret)
			newMaterial->SetScalarParameterValue(SPInfo.Name, Value);
	}

	OutParameterInfo.Reset();
	OutParameterIds.Reset();

	originMaterial->GetAllVectorParameterInfo(OutParameterInfo, OutParameterIds);
	for (FMaterialParameterInfo SPInfo : OutParameterInfo)
	{
		FLinearColor Value;
		bool ret = originMaterial->GetVectorParameterValue(SPInfo, Value);
		if (ret)
			newMaterial->SetVectorParameterValue(SPInfo.Name, Value);
	}

	OutParameterInfo.Reset();
	OutParameterIds.Reset();

	originMaterial->GetAllTextureParameterInfo(OutParameterInfo, OutParameterIds);
	for (FMaterialParameterInfo SPInfo : OutParameterInfo)
	{
		UTexture *Value;
		bool ret = originMaterial->GetTextureParameterValue(SPInfo, Value);
		if (ret)
			newMaterial->SetTextureParameterValue(SPInfo.Name, Value);
	}

	OutParameterInfo.Reset();
	OutParameterIds.Reset();

	originMaterial->GetAllFontParameterInfo(OutParameterInfo, OutParameterIds);
	for (FMaterialParameterInfo SPInfo : OutParameterInfo)
	{
		UFont *Value;
		int32 FontPage;
		bool ret = originMaterial->GetFontParameterValue(SPInfo, Value, FontPage);
		if (ret)
			newMaterial->SetFontParameterValue(SPInfo.Name, Value, FontPage);
	}
}
