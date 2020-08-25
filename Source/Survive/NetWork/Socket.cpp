
#include "Socket.h"
#include "asio.hpp"

class AsioSocket {
public:
	asio::io_service _service;
	asio::io_service::work _forever;
	asio::ip::tcp::socket _socket;

	AsioSocket():
		_service(),
		_forever(_service),
		_socket(_service)
	{
	}
};

// ------------------------------------------------------------------
// Socket
Socket::Socket(socket_delegate delegate)
: asio(new AsioSocket())
, _delegate(delegate)
{
	_thread = new std::thread(
		static_cast<std::size_t(asio::io_service::*)()>(&asio::io_service::run), 
		&asio->_service
	);
}

Socket::~Socket()
{
    this->disconnect();
    this->asio->_service.stop();
    this->_thread->join();

	delete _thread;
	delete asio;
}

// Connect & Disconnect

bool Socket::connect(const std::string &remote)
{
    // check
    if (remote.empty())
    {
        NetLog("socket remote address empty");
        return false;
    }

    // clear
    if (this->asio->_socket.is_open())
        this->disconnect();

    // resolve
    auto sep  = remote.find_first_of(':');
    auto host = remote.substr(0, sep);
    auto port = remote.substr(sep + 1);

    asio::ip::tcp::resolver resolver(asio->_service);
    asio::ip::tcp::resolver::query query(host, port);
    asio::ip::tcp::resolver::iterator end;

    asio::error_code ec;
    auto it = resolver.resolve(query, ec);
    if (it == end)
    {
        this->onDisconnect(ec);
        return false;
    }

    // connect
    this->_connecting = true;
    this->asio->_socket.async_connect(it->endpoint(), std::bind(&Socket::onConnected, this, std::placeholders::_1));

    return true;
}

void Socket::disconnect()
{
    // 这里应该仅仅关闭链接，而不应该通知disconnect，因为这个函数是被其它地方主动调用的
    asio::error_code dummy;
    this->asio->_socket.shutdown(asio::ip::tcp::socket::shutdown_both, dummy);
    this->asio->_socket.close(dummy);

    std::lock_guard<std::mutex> lock(this->_mutex);
    this->_cache.clear();

    this->_connecting = false;
    this->_connected  = false;
}

// Send

void Socket::send(const void *data, uint32_t size)
{
    if (!this->asio->_socket.is_open())
        return;
    
    std::lock_guard<std::mutex> lock(this->_mutex);

    bool emit = this->_cache.empty();
    this->_cache.insert(this->_cache.end(), (const uint8_t*)data, (const uint8_t*)data + size);

    if (emit)
        this->send();
}

// Connect Status

bool Socket::connecting() const
{
    return this->_connecting;
}

bool Socket::connected() const
{
    return this->_connected;
}

// Transmit

void Socket::send()
{
    if (!this->_cache.empty() && this->_connected)
    {
        this->asio->_socket.async_send(asio::buffer(this->_cache.data(), this->_cache.size()),
                                 std::bind(&Socket::onSend, this, std::placeholders::_1, std::placeholders::_2));
    }
}

void Socket::recv()
{
    this->asio->_socket.async_receive(asio::buffer(this->_buffer), std::bind(&Socket::onRecv, this, std::placeholders::_1, std::placeholders::_2));
}

// Event

void Socket::onConnected(const asio::error_code &ec)
{
    if (ec)
        return this->onDisconnect(ec);

    this->_connecting = false;
    this->_connected  = true;
    
    // first send
    {
        std::lock_guard<std::mutex> lock(this->_mutex);
        this->send();
    }

    // emit receive
    this->recv();
    
    this->asio->_service.post([&] () {
        this->_delegate(*this, Event::Connected, {});
    });
}

void Socket::onDisconnect(const asio::error_code &ec)
{
    // 断线通知在应用层采用心跳包来检测
    NetLog("socket disconnect: %s", ec.message().c_str());

    // 只有被动关闭才会通知
    if (this->asio->_socket.is_open())
    {
        this->asio->_service.post([&] () {
            this->disconnect();
            this->_delegate(*this, Event::Disconnect, {});
        });
    }
}

void Socket::onRecv(const asio::error_code &ec, std::size_t bytes)
{
    if (bytes)
    {
        this->asio->_service.post(std::bind([&] (std::vector<uint8_t>& b) {
            this->_delegate(*this, Event::Read, std::move(b));
        }, std::vector<uint8_t>(this->_buffer.begin(), this->_buffer.begin() + bytes)));
    }
    
    if (ec)
        return this->onDisconnect(ec);

    // continue recv
    this->recv();
}

void Socket::onSend(const asio::error_code &ec, std::size_t bytes)
{
    if (ec)
        return this->onDisconnect(ec);
    
    std::lock_guard<std::mutex> lock(this->_mutex);

    // send remaining bytes
    this->_cache.erase(this->_cache.begin(), this->_cache.begin() + bytes);
    this->send();

    this->asio->_service.post([&] () {
        this->_delegate(*this, Event::Write, {});
    });
}
