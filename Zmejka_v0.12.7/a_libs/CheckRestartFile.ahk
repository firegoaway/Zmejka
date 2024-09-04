CheckRestartFile(filePath)
{
    SplitPath, filePath, , dir

    searchPattern := dir . "\*.restart"

    fileList := ""

    Loop, Files, %searchPattern%
    {
        fileList .= A_LoopFileLongPath . "`n"
    }

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

