Remove_HCL_Lines(filePath)
{
    if not FileExist(filePath)
    {
        ToolTip, Файл не найден: %filePath%
        Sleep, 500
        ToolTip
        return
    }

    FileRead, fileContent, %filePath%

    newContent := ""

    Loop, Parse, fileContent, `n, `r
    {
        line := A_LoopField

        if InStr(line, "HYDROGEN CHLORIDE") != 0
            continue

        if RegExMatch(line, "^&ZONE")
            continue

        newContent .= line . "`r`n"
    }

    FileDelete, %filePath%
    FileAppend, %newContent%, %filePath%

    ToolTip, % "Удаление строк, содержащих HYDROGEN CHLORIDE и начинающихся с &ZONE, завершено."
    Sleep, 500
    ToolTip
    return
}
