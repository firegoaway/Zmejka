Process_MISC_Line_to_FDS5(filePath)
{
    if not FileExist(filePath)
	{
        ToolTip, Файл не найден: %filePath%
		Sleep, 500
		ToolTip
        return
    }
    
    FileRead, fileContent, %filePath%
    
    newFileContent := ""
    
    Loop, Parse, fileContent, `n, `r
    {
        line := A_LoopField
        
        if (InStr(line, "&MISC") != 0)
		{
            line := RegExReplace(line, "\s*MAX_LEAK_PATHS=[^/]*")
            line := RegExReplace(line, "\s*VISIBILITY_FACTOR=[^/]*")
            line := RegExReplace(line, "\s*BNDF_DEFAULT=[^/]*")
			line := RegExReplace(line, "\s*MAXIMUM_VISIBILITY=[^/]*")
        }
        
        newFileContent .= line "`n"
    }

    FileDelete, %filePath%
    FileAppend, %newFileContent%, %filePath%
}
/*
Process_MISC_Line_to_FDS5("E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds\ffdb7ff7_nfs.fds")
MsgBox, Done!
*/
