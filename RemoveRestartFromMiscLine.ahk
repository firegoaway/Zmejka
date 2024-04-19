RemoveRestartFromMiscLine(filePath) {
    ; Read the .fds file
    FileRead, fdsContent, %filePath%

    ; Find the line starting with "&MISC" and ending with "/"
    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
  
    ; Find ", RESTART=T" and ending with "/"
    RegExMatch(miscLine, "(.*\, RESTART=T.*\/)", restartContent)

    ; Check if a line is found
    if ((miscLine != "") && (restartContent != "")) {
        ; Remove ", RESTART=T" from the line
        modifiedLine := StrReplace(restartContent, ", RESTART=T", "")

        ; Replace the original line with the modified line
        StringReplace, miscLine, miscLine, %restartContent%, %modifiedLine%
    } Else {
        if (restartContent = "") {
            ; MsgBox, % restartContent " does not exist."
        }
    }

    ; Save the modified .fds file
    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%

    ; Return success or failure
    return (miscLine && restartContent)
}