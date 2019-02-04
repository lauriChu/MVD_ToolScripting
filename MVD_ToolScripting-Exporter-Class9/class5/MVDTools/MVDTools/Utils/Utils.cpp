#include "mvd_platform.h"
#include "Utils.h"

std::wstring StringToW(std::string orgstring) {

    std::wstring str2(orgstring.length(), L' ');
    std::copy(orgstring.begin(), orgstring.end(), str2.begin());

    return str2;
}

std::string WToString(TSTR orgstring) {

    const wchar_t* wStr = orgstring.data();
    std::wstring ws(wStr);
    std::string str(ws.begin(), ws.end());

    return str;
}
