WatchFolderForOutFiles(folderPath, OutfilePaths)
{
    Loop
    {
        Loop, Files, %folderPath%\*.out
        {
            fileName := A_LoopFileName
			
            if (IsInArray(OutfilePaths, fileName))
            {
                OutfilePath := A_LoopFileFullPath
                return
            }
        }
        Sleep, 1000
    }
}

IsInArray(array, value)
{
    for index, val in array
    {
        if (val = value)
            return true
    }
    return false
}
