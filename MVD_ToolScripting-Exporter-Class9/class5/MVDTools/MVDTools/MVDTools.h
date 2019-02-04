#ifndef MVDTOOLS_H
#define MVDTOOLS_H

extern TCHAR *GetString(int id);
extern HINSTANCE hInstance;

class MaxExporter;

#define MVDTools_CLASS_ID	Class_ID(0x5a3e663e, 0x6a675ba3)

#define OPEN_LAYERBOSS 0x01

class MVDTools : public GUP {
public:

    static HWND hParams;

    // GUP Methods
    virtual DWORD	Start();
    virtual void	Stop();
    virtual void DeleteThis();
    DWORD_PTR Control(DWORD parameter);

    // Loading/Saving
    IOResult Save(ISave *isave);
    IOResult Load(ILoad *iload);

    //Constructor/Destructor
    MVDTools();
    ~MVDTools();
};



class MVDToolsClassDesc : public ClassDesc2 {
public:
    int 			IsPublic() { return TRUE; }
    void *			Create(BOOL loading = FALSE) { return new MVDTools(); }
    const TCHAR *	ClassName() { return GetString(IDS_CLASS_NAME); }
    SClass_ID		SuperClassID() { return GUP_CLASS_ID; }
    Class_ID		ClassID() { return MVDTools_CLASS_ID; }
    const TCHAR* 	Category() { return GetString(IDS_CATEGORY); }

    const TCHAR*	InternalName() { return _T("MVDTools"); }	// returns fixed parsable name (scripter-visible name)
    HINSTANCE		HInstance() { return hInstance; }					// returns owning module handle
};

#endif
