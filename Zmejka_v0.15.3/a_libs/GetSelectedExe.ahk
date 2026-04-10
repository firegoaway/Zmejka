GetSelectedExe(ByRef filePath)
{
    FileSelectFile, filePath, 3, , Select .exe file, Select .exe file (*.exe)|*.exe
    if ErrorLevel <> 1
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
}