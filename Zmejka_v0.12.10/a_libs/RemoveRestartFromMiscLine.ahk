RemoveRestartFromMiscLine(filePath)
{
	FileRead, fdsContent, %filePath%
  
	pattern := "\&MISC\s(.*?)(/)"

	if (RegExMatch(fdsContent, pattern, miscLine))
	{
		modifiedLine := RegExReplace(miscLine, "\sRESTART=T", "")

		fdsContent := StrReplace(fdsContent, miscLine, modifiedLine)

		FileDelete, %filePath%
		FileAppend, %fdsContent%, %filePath%

		return (miscLine && modifiedLine)
	}
	return false
}

RemoveRestartFromMiscLineFDS5(filePath)
{
	FileRead, fdsContent, %filePath%
  
	pattern := "\&MISC\s(.*?)(/)"

	if (RegExMatch(fdsContent, pattern, miscLine))
	{
		modifiedLine := RegExReplace(miscLine, "\sRESTART=.TRUE.", "")

		fdsContent := StrReplace(fdsContent, miscLine, modifiedLine)

		FileDelete, %filePath%
		FileAppend, %fdsContent%, %filePath%

		return (miscLine && modifiedLine)
	}
	return false
}

; Example usage:
; filePath := "path_to_your_fds_file.fds"
; success := RemoveRestartFromMiscLine(filePath)
; if (success)
;     MsgBox, The line has been successfully modified.
; else
;     MsgBox, No modification was needed or the line was not found.


/*
filePath := "E:\ЗАДАЧИ\(Выполнено) Москва Профсоюзная 136 к.1\Склад Озон\Results\605dccfa\fds\zmejka_test\605dccfa.fds"
RemoveRestartFromMiscLine(filePath)
Return
*/

