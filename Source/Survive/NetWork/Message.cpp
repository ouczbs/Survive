// Copyright 2018-2020 X.D. Network Inc. All Rights Reserved.

#include "Message.h"
#include "System/MessageManager.h"
using namespace std::placeholders;

Message::Message(const std::string &remote)
: _remote(remote)
,_socket(new Socket(std::bind(&Message::onSocket, this, _1, _2, _3)))
{   
}

Message::~Message()
{
}

void Message::PostConnect()
{
    if (!_socket->connected() && !_socket->connecting())
        _socket->connect(_remote);
}

void Message::PostDisconnect()
{
	if (_socket->connected() || _socket->connecting())
	{
		_socket->disconnect();
	}
}

void Message::SendPbcMessage(const std::string & buffer, int type, int id)
{
	
	//UE_LOG(LogTemp, Display, TEXT("Send protobuf, Msg: %s, size[%d]."), *FString(msg.c_str()), msg.size());

	// 协议格式
	// --------------------------------------------
	// |Length(2)|MessageType(2)|Cmd(2)Payload(Length)|
	// --------------------------------------------
	uint16_t header = buffer.size() + 6;
	_socket->send(&header, 2);
	header = type;
	_socket->send(&header, 2);
	header = id;
	_socket->send(&header, 2);
	_socket->send(buffer.data(), buffer.size());
}

void Message::OnSendMessage()
{
}

void Message::OnReceiveMessage(std::vector<uint8_t> msg)
{
    // 协议格式
    // --------------------------------------------
    // |Length(2)|MessageType(2)|Cmd(2)Payload(Length)|
    // --------------------------------------------
    if (_buffer.empty())
        _buffer = std::move(msg);
    else
        _buffer.insert(_buffer.end(), msg.begin(), msg.end());
    
    auto size = _buffer.size();
    if (size < 6)  // 至少4个字节吧
        return;
	while (_buffer.size() > 0)
	{
		size = _buffer.size();
		auto length = *(uint16_t*)(&_buffer[0]);
		if (size < length)  // 没收到完整协议就等待
			return;
		int16 type = *(int16*)(&_buffer[2]);
		int16  id = *(int16*)(&_buffer[4]);
		std::string pb(_buffer.begin() + 6, _buffer.begin() + length);
		//UE_LOG(LogTemp, Display, TEXT("Recv protobuf, Msg: %s, size[%d], buf[%d]."), *FString(pb.c_str()), msg.size(), _buffer.size());
		_buffer.erase(_buffer.begin(), _buffer.begin() + length);
		if (OnLuaRcvPbcMsg) 
		{
			OnLuaRcvPbcMsg(pb , type ,id);
		}
	}
}

void Message::OnServerConnected(std::string remote)
{

}

void Message::OnServerDisconnected(std::string remote)
{
	if (AMessageManager::CheckValid()) {
		AMessageManager::I()->Disconnect();
	}
}

void Message::setMessageSendEventDelegate(FSendMessageEvent msgDelegate)
{
	SendEventDelegate = msgDelegate;
}

void Message::onSocket(Socket& s, int e, std::vector<uint8_t> b)
{
    switch (e)
    {
        case Socket::Event::Connected:
            this->OnServerConnected(_remote);
            break;

        case Socket::Event::Disconnect:
            this->OnServerDisconnected(_remote);
            break;

        case Socket::Event::Read:
            this->OnReceiveMessage(std::move(b));
            break;

        case Socket::Event::Write:
			this->OnSendMessage();
            break;

        default:
            UE_LOG(LogTemp, Error, TEXT("Message: unknown socket event: %d"), (int)e);
            break;
    }
}

