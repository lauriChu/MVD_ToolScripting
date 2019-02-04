#include "mvd_platform.h"
#include "MVDTools.h"
#include "Exporter/MaxExporter.h"
#include <maxscript\maxscript.h>
#include <maxscript\macros\define_instantiation_functions.h>

static MVDToolsClassDesc MVDToolsDesc;
ClassDesc2* GetMVDToolsDesc() { return &MVDToolsDesc; }
static MaxExporter * exporter;

DWORD MVDTools::Start()
{
    exporter = new MaxExporter();
    exporter->ExportMenu();

    return GUPRESULT_KEEP;
}

void MVDTools::Stop()
{

}

void MVDTools::DeleteThis()
{
    delete this;
}

DWORD_PTR MVDTools::Control(DWORD parameter)
{
    return DWORD_PTR();
}

// On save scene
IOResult MVDTools::Save(ISave * isave)
{
    return IO_OK;
}

// On load scene
IOResult MVDTools::Load(ILoad * iload)
{
    return IO_OK;
}

MVDTools::MVDTools()
{

}

MVDTools::~MVDTools()
{

}

def_visible_primitive(IntervalArray, "IntervalArray");
def_visible_primitive(ExportScene, "ExportScene");

Value* IntervalArray_cf(Value **arg_list, int count)
{
    return &ok;
}

Value* ExportScene_cf(Value **arg_list, int count)
{
    check_arg_count(ExportScene, 1, count);
    Value* values = arg_list[0];
    const wchar_t * path = values->to_string();
    std::wstring ws(path);
    std::string final_path(ws.begin(), ws.end());
    exporter->ExportScene(final_path);

    return &ok;
}