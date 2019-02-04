#include "mvd_platform.h"
#include "MaxExporter.h"
#include "MaxCallback.h"
#include "actiontable.h"
#include "imenuman.h"
#include "ilayer.h"

std::string WToString(TSTR orgstring) {

    const wchar_t* wStr = orgstring.data();
    std::wstring ws(wStr);
    std::string str(ws.begin(), ws.end());

    return str;
}

std::string pointString(Point3 new_point) {
    
    return "[" + std::to_string(new_point.x) 
                + ", " + std::to_string(new_point.y)
                + ", " + std::to_string(new_point.z) + "]";
}

MaxExporter::MaxExporter()
{
    callback = new MaxCallback();
}

MaxExporter::~MaxExporter()
{

}

// Export 
void MaxExporter::ExportMenu()
{
    IMenuManager * menuman = GetCOREInterface()->GetMenuManager();
    IActionManager * menuaction = GetCOREInterface()->GetActionManager();
    IMenu * menubar = menuman->GetMainMenuBar();
    DynamicMenu * dynamic_menu = new DynamicMenu(callback);

    dynamic_menu->BeginSubMenu(L"MVD Tools");
    dynamic_menu->AddItem(0, 0, L"Export Menu");
    dynamic_menu->AddItem(0, 1, L"About");
    dynamic_menu->EndSubMenu();

    menubar->AddItem(dynamic_menu->GetMenu()->GetItem(0), -1);
    menuman->UpdateMenuBar();
}

bool MaxExporter::ExportScene(const std::string & filepath)
{
    //Get the interface pointer that enables access to almost
    //all the functionality of Max
    Interface* ip = GetCOREInterface();

    //ILayerManager* lm = GetCOREInterface13()->GetLayerManager();
    INode* pRootNode = ip->GetRootNode();
    int objectCount = pRootNode->NumberOfChildren();
    nlohmann::json jsonObjects = nlohmann::json::array();

    // Looping through all the entities on the scene
    for (int i = 0; i < objectCount; i++)
    {
        //Get the object
        INode* cNode = pRootNode->GetChildNode(i);
        nlohmann::json entity;

        // Component name 
        {
            std::string name = WToString(cNode->GetName());
            entity["name"] = name;
        }

        // Component transform
        {
            nlohmann::json transform = entity["transform"];
            Matrix3 mat = cNode->GetNodeTM(ip->GetTime());
            Point3 translation = mat.GetTrans();
            float yaw, pitch, roll;
            mat.GetYawPitchRoll(&yaw, &pitch, &roll);

            transform["translation"] = pointString(translation);
            transform["rotation"] = pointString(Point3(yaw, pitch, roll));
            transform["scale"] = pointString(Point3(mat.GetColumn(2).x, mat.GetColumn(2).y, mat.GetColumn(2).z));
        }

        jsonObjects.push_back(entity);
    }

    std::ofstream myfile;
    myfile.open(filepath + "\export_scene.json");
    myfile << jsonObjects;
    myfile.close();

    return true;
}
