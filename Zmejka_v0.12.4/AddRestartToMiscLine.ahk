AddRestartToMiscLine(filePath)
{
    ; Read the .fds file
    FileRead, fdsContent, %filePath%

    ; Find the line starting with "&MISC" and ending with "/"
    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
	
	; Find "RESTART=T" and ending with "/"
    RegExMatch(fdsContent, "(\, RESTART=T.*\/)", restartContent)

    ; Check if a line is found
    if ((miscLine != "") && (restartContent = ""))
	{
        ; Add "RESTART=T" to the found line
        modifiedLine := StrReplace(miscLine, "/", ", RESTART=T/")
        ; Replace the original line with the modified line
        StringReplace, fdsContent, fdsContent, %miscLine%, %modifiedLine%
    } Else If (restartContent != "")
	{
		;	MsgBox, % restartContent " already exists."
	}

    ; Save the modified .fds file
    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%

    ; Return success or failure
	
    return ((miscLine != "") && (restartContent = "") ? 1 : 0)
}

/*
CheckRestartTag(filePath) {
	; Read the .fds file
    FileRead, fdsContent, %filePath%

    ; Find the line starting with "&MISC" and ending with "/"
    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
	
	; Find "RESTART=T" and ending with "/"
    RegExMatch(fdsContent, "(\, RESTART=T.*\/)", restartContent)

    ; Check if a line is found
    if ((miscLine != "") && (restartContent = "")) {
		;	MsgBox, 4096, Restart tag check, %restartContent% -> UnChecked.
    } Else If (restartContent != "") {
		;	MsgBox, 4096, Restart tag check, %restartContent% -> checked.
	}

    ; Save the modified .fds file
    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%

    ; Return success or failure
	
    return ((miscLine != "") && (restartContent = ""))
}
*/

CheckRestartTag(filePath) {
    ; Read the .fds file
    FileRead, fdsContent, %filePath%

    ; Match the pattern in the string that corresponds to a MISC line containing RESTART=T
    RegExMatch(fdsContent, "(\&MISC[^\/]*RESTART=T[^\/]*\/)", restartContent)

    ; Return 1 if RESTART=T is found in the &MISC line, else return 0
    return restartContent != "" ? 1 : 0
}
