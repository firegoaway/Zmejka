AddRestartToMiscLine(filePath) {
    ; Read the .fds file
    FileRead, fdsContent, %filePath%

    ; Find the line starting with "&MISC" and ending with "/"
    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
	
	; Find "RESTART=T" and ending with "/"
    RegExMatch(fdsContent, "(\, RESTART=T.*\/)", restartContent)

    ; Check if a line is found
    if ((miscLine != "") && (restartContent = "")) {
        ; Add "RESTART=T" to the found line
        modifiedLine := StrReplace(miscLine, "/", ", RESTART=T/")

        ; Replace the original line with the modified line
        StringReplace, fdsContent, fdsContent, %miscLine%, %modifiedLine%
    } Else {
		if (restartContent != "") {
			;MsgBox, % restartContent " already exists."
		}
	}

    ; Save the modified .fds file
    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%

    ; Return success or failure
    return ((miscLine != "") && (restartContent = ""))
}