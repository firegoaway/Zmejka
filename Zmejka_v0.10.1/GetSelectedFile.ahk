GetSelectedFile(ByRef folderPath, ByRef fileName, ByRef filePath)
{
    FileSelectFile, filePath, 3, , Select .fds file, Select .fds file (*.fds)|*.fds
    ; Check if a file is selected
    if ErrorLevel <> 1
    {
        ; Extract the file name from the path
        folderPath := RegExReplace(filePath, "(.*\\).*", "$1")
			folderPath := SubStr(folderPath, 1, StrLen(folderPath) - 1)
        fileName := RegExReplace(filePath, ".+\\(.+)$", "$1")
			fileName := SubStr(fileName, 1, StrLen(fileName) - 4)
		; Run Notepad and open the file
        ;Run, notepad.exe %filePath%
        
        ; Display the file name in a message box
        ;MsgBox, The selected file is: %fileName%
    }
    else
    {
        ;MsgBox, No file selected!
    }
}