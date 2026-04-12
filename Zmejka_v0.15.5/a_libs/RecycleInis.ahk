DeleteIniFiles()
{
    inisFolderPath := A_ScriptDir "\inis"
    
    Loop, Files, %inisFolderPath%\*_*.ini
    {
        FileDelete, %A_LoopFileFullPath%
    }
}
