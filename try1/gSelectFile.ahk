Gui, Add, Button, x10 y10 w100 h30 gSelectFile, Select File
Gui, Show
return

SelectFile:
    FileSelectFile, filepath, 1, , Select .fds File, FDS Files (*.fds)
    if (filepath)
    {
        filepaths.Push(filepath) ; Add the selected filepath to the array
        GuiControl,, FilesList, % GenerateFilesList() ; Update the list of file buttons in the GUI
    }
return

GenerateFilesList()
{
    filesList := ""
    Loop, filepaths.Length()
    {
        file := filepaths[A_Index-1]
        filesList .= "Button`nStart " A_Index ": " file "`nPause " A_Index ": " file "`nStop " A_Index ": " file "`nKill " A_Index ": " file "`n`n"
    }
    return filesList
}

Gui, Add, Text, xm y50, Files:
Gui, Add, Text, xm y70 w200 h150 vFilesList, % GenerateFilesList()
Gui, Show
return

Gui, Add, Button, x10 y50 w100 h30 gStart, Start
Gui, Add, Button, x120 y50 w100 h30 gPause, Pause
Gui, Add, Button, x10 y90 w100 h30 gStop, Stop
Gui, Add, Button, x120 y90 w100 h30 gKill, Kill
Gui, Show
return

Button_Start:
    index := SubStr(A_GuiControl, 13) ; Extract the index from the button control name
    Run, fds run %filepaths%[index-1]
return

Button_Pause:
    index := SubStr(A_GuiControl, 14) ; Extract the index from the button control name
    Run, fds pause %filepaths%[index-1]
return

Button_Stop:
    index := SubStr(A_GuiControl, 13) ; Extract the index from the button control name
    Run, fds stop %filepaths%[index-1]
return

Button_Kill:
    index := SubStr(A_GuiControl, 12) ; Extract the index from the button control name
    Run, fds kill %filepaths%[index-1]
return