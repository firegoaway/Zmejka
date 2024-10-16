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
			; Заменяем MAX_LEAK_PATHS на SUPPRESSION=.FALSE.
			line := RegExReplace(line, "\s*MAX_LEAK_PATHS=[^\s/]*", " SUPPRESSION=.FALSE.")
			
			; Заменяем VISIBILITY_FACTOR на BAROCLINIC=.FALSE.
			line := RegExReplace(line, "\s*VISIBILITY_FACTOR=[^\s/]*", " BAROCLINIC=.FALSE.")
			
			; Удаляем BNDF_DEFAULT
			line := RegExReplace(line, "\s*BNDF_DEFAULT=[^\s/]*", "")
			
			; Удаляем MAXIMUM_VISIBILITY
			line := RegExReplace(line, "\s*MAXIMUM_VISIBILITY=[^\s/]*", "")
		}
		
		if (InStr(line, "&TIME") != 0)
		{
			;line := RegExReplace(line, "/", " LOCK_TIME_STEP=.TRUE. SYNCHRONIZE=.FALSE./")
			line := RegExReplace(line, "/", " RESTRICT_TIME_STEP=.FALSE. SYNCHRONIZE=.FALSE./")
		}
		
		if (InStr(line, "&DUMP") != 0)
		{
			line := RegExReplace(line, "/", " FLUSH_FILE_BUFFERS=.FALSE./")
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
