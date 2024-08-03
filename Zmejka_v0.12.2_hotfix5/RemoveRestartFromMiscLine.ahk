RemoveRestartFromMiscLine(filePath)
{
	; Read the .fds file
	FileRead, fdsContent, %filePath%

	; Use a regular expression to find and modify the &MISC line containing "RESTART=T"
	if (RegExMatch(fdsContent, "i)(&(MISC.+/))", miscLine))
	{
		; If the line is found, remove ", RESTART=T" from it
		modifiedLine := RegExReplace(miscLine1, "\, RESTART=T", "")
		; Replace the original line within the full file content
		fdsContent := StrReplace(fdsContent, miscLine1, modifiedLine)
	}

	; Save the modified .fds file
	FileDelete, %filePath%
	FileAppend, %fdsContent%, %filePath%

	; Check if the replacement was successful
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

