; Function to check for the existence of ".restart" files in the same directory as the provided path
CheckRestartFile(filePath)
{
    ; Extract the directory from the provided file path
    SplitPath, filePath, , dir

    ; Construct the search pattern for ".restart" files
    searchPattern := dir . "\*.restart"

    ; Initialize an empty message to store possible file list
    fileList := ""

    ; Loop through all files matching the search pattern
    Loop, Files, %searchPattern%
    {
        ; Append found files to the message
        fileList .= A_LoopFileLongPath . "`n"  ; Append file path and add a new line
    }

    ; Determine if restart files were actually found
    if (fileList != "")
    {
        MsgBox, Restart file(s) found at:`n %fileList%
    }
    else
    {
        MsgBox, No restart file found in the directory.
    }
	return fileList
}

/*
pathToFile := "E:\ЗАДАЧИ\(Выполнено) Москва Профсоюзная 136 к.1\Склад Озон\Results\605dccfa\fds\zmejka_test\"
CheckRestartFile(pathToFile)
*/

