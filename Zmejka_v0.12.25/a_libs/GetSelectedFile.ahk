GetSelectedFile(ByRef folderPath, ByRef fileName, ByRef filePath)
{
    FileSelectFile, filePath, 3, , Выберите файл сценария .fds, Выберите файл сценария .fds (*.fds)|*.fds
    if !ErrorLevel
    {
        folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
		folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
		fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		
		IniWrite, %filePath%, %A_ScriptDir%\..\inis\filePath.ini, filePath, filePath
    }
    else
    {
        ;MsgBox, GetSelectedFile returned: Файл сценария не выбран!
    }
}