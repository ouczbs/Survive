#include "NetLog.h"
//#include "asio.hpp"
void NetLogOutput(const char *text)
{
    UE_LOG(LogTemp , Display, TEXT("%s"), *FString(text));
}
