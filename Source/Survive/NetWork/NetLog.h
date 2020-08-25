#pragma once

#include "CoreMinimal.h"
#include <string>

void NetLogOutput(const char *text);

inline void NetLog(const char *fmt)
{
    // to improve performance, return fmt if no other params
    NetLogOutput(fmt);
}

template <typename ...Args>
void NetLog(const char *fmt, Args... args)
{
    auto size = ::snprintf(nullptr, 0, fmt, args...);
    if (size <= 0)
        return;
    
    std::string ret(++size, '\0');
    
    size = ::snprintf(&ret[0], static_cast<std::size_t>(size), fmt, args...);
    if (size <= 0)  // re-check
        return;
    
    ret.resize(static_cast<std::size_t>(size));
    NetLogOutput(ret.c_str());
}
