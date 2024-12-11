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
        if InStr(line, "HYDROGEN CHLORIDE") = 0
        {
            newContent .= line . "`r`n"
        }
    }

    FileDelete, %filePath% 
    FileAppend, %newContent%, %filePath%

    ToolTip, % "Удаление строк, содержащих HYDROGEN CHLORIDE, завершено."
	Sleep, 500
	ToolTip
    return
}

/*
Remove_HCL_Lines("E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds\ffdb7ff7_nfs.fds")
*/
