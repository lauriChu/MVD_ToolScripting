#ifndef MAXEXPORTER_H
#define MAXEXPORTER_H

class MaxCallback;

class MaxExporter {

public:
    MaxExporter();
    ~MaxExporter();

    void ExportMenu();
    bool ExportScene(const std::string & filepath);

    MaxCallback * callback;
};

#endif