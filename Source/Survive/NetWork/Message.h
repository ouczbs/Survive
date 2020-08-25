// Copyright 2018-2020 X.D. Network Inc. All Rights Reserved.

#pragma once
#include "CoreMinimal.h"

#include <string>
#include <vector>
#include <memory>
#include <functional>
#include "Socket.h"

#include "HAL/PlatformFilemanager.h"
#include "HAL/FileManager.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <stdlib.h>

class Socket;
class FJsonObject;
class FConvertJson2pb;

DECLARE_DELEGATE(FSendMessageEvent)

class Message
{
public:

	using LuaRcvPbcEvt = std::function<void(const std::string, int16 type, int16 id)>;
	LuaRcvPbcEvt OnLuaRcvPbcMsg;

    explicit Message(const std::string &remote = "mmm.io:9876");
	~Message();

	void PostConnect();
	void PostDisconnect();

	void SendPbcMessage(const std::string& buffer, int type, int id);

	void OnSendMessage();
    void OnReceiveMessage(std::vector<uint8_t> msg);
    void OnServerConnected(std::string remote);
    void OnServerDisconnected(std::string remote);

	void setMessageSendEventDelegate(FSendMessageEvent msgDelegate);

	TSharedPtr<FConvertJson2pb> GetJson2Pb() const { return _convertjson2pb; }

protected:
    void onSocket(Socket& s, int e, std::vector<uint8_t> b);

protected:
	FSendMessageEvent SendEventDelegate;
    TSharedPtr<FConvertJson2pb> _convertjson2pb;
    
private:
    std::string _remote;
    std::vector<uint8_t> _buffer;
    std::unique_ptr<Socket> _socket;
};
