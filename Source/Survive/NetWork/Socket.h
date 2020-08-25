/**
 * Socket
 * 网络通信底层接口
 * -----------------------------------------------------------------------------
 * Author: Jian Chen
 * Email:  admin@chensoft.com
 * -----------------------------------------------------------------------------
 */
#pragma once

#include "CoreMinimal.h"
#include <thread>
#include <mutex>
#include <vector>
#include <array>
#include "NetLog.h"
#include <functional>

class AsioSocket;

class Socket
{
public:
    enum Event {Connected = 1, Disconnect, Read, Write};

    typedef std::function<void (Socket&, int, std::vector<uint8_t>)> socket_delegate;

public:
    Socket(socket_delegate delegate);
    ~Socket();

public:
    /**
     * 连接 & 断开服务器
     */
    bool connect(const std::string &remote = "");
    void disconnect();

    /**
     * 发送数据
     */
    void send(const void *data, uint32_t size);
        
public:
    /**
     * 连接状态
     */
    bool connecting() const;
    bool connected() const;

private:
    /**
     * 收发数据
     */
    void send();
    void recv();

    /**
     * 网络事件
     */
    void onConnected(const std::error_code &ec);
    void onDisconnect(const std::error_code &ec);
    void onRecv(const std::error_code &ec, std::size_t bytes);
    void onSend(const std::error_code &ec, std::size_t bytes);

private:
    // underlying
    std::thread* _thread;
	AsioSocket* asio;

    // properties
    std::mutex _mutex;
    std::vector<uint8_t> _cache;
    std::array<uint8_t, 4096> _buffer;

    socket_delegate _delegate;

    bool _connecting = false;
    bool _connected  = false;
};


namespace asio {
	namespace detail {
		template <typename Exception>
		void throw_exception(const Exception& e)
		{
			check(false);
		}
	}
}