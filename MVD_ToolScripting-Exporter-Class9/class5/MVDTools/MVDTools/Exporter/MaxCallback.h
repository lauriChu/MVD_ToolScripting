#ifndef MAXCALLBACK_H
#define MAXCALLBACK_H


class MaxCallback : public DynamicMenuCallback {

public:
    virtual void MenuItemSelected(int item);

    void ExportMenu();
    void AboutMenu();
};

#endif