RemoveRestartFromMiscLine(filePath)
{
	FileRead, fdsContent, %filePath%

	if (RegExMatch(fdsContent, "i)(&(MISC.+/))", miscLine))
	{
		modifiedLine := RegExReplace(miscLine1, "\, RESTART=T", "")
		fdsContent := StrReplace(fdsContent, miscLine1, modifiedLine)
	}

	FileDelete, %filePath%
	FileAppend, %fdsContent%, %filePath%

	return (miscLine1 && modifiedLine)
}

RemoveRestartFromMiscLineFDS5(filePath)
{
	FileRead, fdsContent, %filePath%

	if (RegExMatch(fdsContent, "i)(&(MISC.+/))", miscLine))
	{
		modifiedLine := RegExReplace(miscLine1, "\, RESTART=\.TRUE\.", "")
		fdsContent := StrReplace(fdsContent, miscLine1, modifiedLine)
	}

	FileDelete, %filePath%
	FileAppend, %fdsContent%, %filePath%

	return (miscLine1 && modifiedLine)
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

