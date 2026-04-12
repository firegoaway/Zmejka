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
			
		if RegExMatch(line, "^&CTRL")
            continue

        newContent .= line . "`r`n"
    }

    FileDelete, %filePath%
    FileAppend, %newContent%, %filePath%

    ToolTip, % "Удаление строк, содержащих HYDROGEN CHLORIDE,`nа также строк начинающихся с &ZONE и с &CTRL, завершено."
    Sleep, 500
    ToolTip
    return
}
