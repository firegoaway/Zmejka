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
		
		; Удаляем CELL_CENTERED=.True. из любой строки
        ; line := RegExReplace(line, "\s*CELL_CENTERED=.True.", "")
        
        if (InStr(line, "&MISC") != 0)
		{
			; Заменяем MAX_LEAK_PATHS на SUPPRESSION=.FALSE.
			;line := RegExReplace(line, "\s*MAX_LEAK_PATHS=[^\s/]*", " SUPPRESSION=.FALSE.")
			line := RegExReplace(line, "\s*MAX_LEAK_PATHS=[^\s/]*", " ")
			
			; Заменяем VISIBILITY_FACTOR на BAROCLINIC=.FALSE.
			line := RegExReplace(line, "\s*VISIBILITY_FACTOR=[^\s/]*", " BAROCLINIC=.FALSE.")
			
			; Удаляем BNDF_DEFAULT
			line := RegExReplace(line, "\s*BNDF_DEFAULT=[^\s/]*", "")
			
			; Удаляем MAXIMUM_VISIBILITY
			line := RegExReplace(line, "\s*MAXIMUM_VISIBILITY=[^\s/]*", "")
			
			; Удаляем EXTERNAL_FILENAME
			;line := RegExReplace(line, "\s*EXTERNAL_FILENAME=[^\s/]*", "") Отправлено в RemoveExternalFilenameParameter.ahk
		}
		
		if (InStr(line, "&TIME") != 0)
        {
            ;	line := RegExReplace(line, "/", " LOCK_TIME_STEP=.TRUE. SYNCHRONIZE=.FALSE./")
            ;	line := RegExReplace(line, "/", " RESTRICT_TIME_STEP=.FALSE. SYNCHRONIZE=.FALSE./")
			
			; Удаляем DT_EXTERNAL
			line := RegExReplace(line, "\s*DT_EXTERNAL=[^\s/]*", "")
        }
		
		if (InStr(line, "&DUMP") != 0)
        {
            ; Удаляем DIAGNOSTICS_INTERVAL=1, если он существует
            line := RegExReplace(line, "\s*DIAGNOSTICS_INTERVAL=1", "")
            
            ; Добавляем FLUSH_FILE_BUFFERS=.FALSE.
            line := RegExReplace(line, "/", " FLUSH_FILE_BUFFERS=.FALSE./")
        }
        
        newFileContent .= line "`n"
    }

    FileDelete, %filePath%
    FileAppend, %newFileContent%, %filePath%
}
