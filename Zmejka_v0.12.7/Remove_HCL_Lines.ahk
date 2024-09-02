Remove_HCL_Lines(filePath)
{
    FileRead, fileContent, %filePath%
    if ErrorLevel
	{
        MsgBox, Failed to read file!
		Sleep, 500
        return 
    }

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

    ToolTip, Completed the removal of lines containing "HYDROGEN CHLORIDE".
	Sleep, 500
	ToolTip
    return
}

/*
Remove_HCL_Lines("E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds\ffdb7ff7_nfs.fds")
*/
