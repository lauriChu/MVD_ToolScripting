#include "mvd_platform.h"
#include "MaxCallback.h"
#include "actiontable.h"
#include "imenuman.h"
#include "ilayer.h"

/* 
 This class will hold all the actions
 related to the exporting menu.
*/

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


void MaxCallback::MenuItemSelected(int item)
{
    switch (item) {
        case 0: ExportMenu();  break;
        case 1:AboutMenu(); break;
        default: break;
    }
}

// Export 
void MaxCallback::ExportMenu()
{
    // Action to open the menu
    std::string maxscript_code = "createDialog rolloutmvd";
    ExecuteMAXScriptScript(StringToW(maxscript_code).c_str());

}

void MaxCallback::AboutMenu()
{
   // Message about the tools

}
