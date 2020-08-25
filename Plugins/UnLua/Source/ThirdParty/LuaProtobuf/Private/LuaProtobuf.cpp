// Fill out your copyright notice in the Description page of Project Settings.

#include "LuaProtobuf.h"
#include "lua.hpp"
#include "pb.h"
IMPLEMENT_MODULE(FLuaProtobuf, LuaProtobuf);

void FLuaProtobuf::StartupModule()
{
	IModularFeatures::Get().RegisterModularFeature(LUA_LIB_FEATURE_NAME, this);
}

void FLuaProtobuf::ShutdownModule()
{
	IModularFeatures::Get().UnregisterModularFeature(LUA_LIB_FEATURE_NAME, this);
}

void FLuaProtobuf::RegisterLuaLib(lua_State* L)
{
	luaL_requiref(L, "pb", luaopen_pb, 0);
	luaL_requiref(L, "pb.io", luaopen_pb_io, 0);
	luaL_requiref(L, "pb.slice", luaopen_pb_slice, 0);
	luaL_requiref(L, "pb.buffer", luaopen_pb_buffer, 0);
	luaL_requiref(L, "pb.conv", luaopen_pb_conv, 0);
}
void FLuaProtobuf::UnRegisterLuaLib(lua_State* L)
{
	
}
FName FLuaProtobuf::GetLibName()const
{
	return TEXT("LuaProtobuf");
}