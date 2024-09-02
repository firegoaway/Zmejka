RunSimulationFDS5(filePath)
{
	execPath := A_ScriptDir "\FDS5\fds5_mpi_win_64.exe"
	
	SplitPath, filePath, fileName, dir
	
	StringReplace, fileName, fileName, _nfs.fds, , All
	
	SetWorkingDir, %dir%
    
    Run, "%execPath%" "%filePath%", "%dir%", , PID
	
	/*
	WinWait ahk_pid %PID%

    WinWaitClose ahk_pid %PID%
	
	MsgBox, % "Моделирование сценария " fileName ".fds завершено!"
	*/
	Sleep, 100
}

Proceed_Renaming(directory, filePath)
{
    SplitPath, filePath, fileName, dir
	
	StringReplace, fileName, fileName, _nfs.fds, , All
	
	SetWorkingDir, %dir%
	
	; Loop through all files in the specified directory
    Loop, Files, % directory "\" fileName "*.*"
    {
        ; Get the full path and name of the current file
        FullFilePath := A_LoopFileFullPath
        FileName := A_LoopFileName
        FileExt := A_LoopFileExt
		
		if (FileExt = "q")
		{
            continue
        }
		
		if (FileExt = "sf")
		{
            ;continue
        }
        
        ; Remove leading zeros from each numeric section of the file name
        ; Split the filename by underscore
        NameParts := StrSplit(FileName, "_")
        CleanFileName := ""
        
        ; Iterate over each part of the split name
        Loop, % NameParts.MaxIndex()
        {
            Part := NameParts[A_Index]
            ; Use regex to remove leading zeros from numbers
            CleanPart := RegExReplace(Part, "^(0+)(\d)", "$2")
            
            ; Build the new filename part by part
            CleanFileName .= (A_Index = 1 ? "" : "_") . CleanPart
        }
        
        ; Check if the file extension is ".bf" and change it to ".bnd"
        if (FileExt = "bf")
		{
            ;CleanFileName := RegExReplace(CleanFileName, "\.bf$", ".bnd")
        }
        
        ; Construct the new file path
        NewFilePath := directory "\" CleanFileName

        ; Rename the file if the name has changed
        if (FullFilePath != NewFilePath)
		{
            FileMove, %FullFilePath%, %NewFilePath%
        }
    }
}

/*
filePath := "E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds\ffdb7ff7_nfs.fds"
fileFolder := "E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds"
RunSimulationFDS5(filePath)
;Proceed_Renaming(fileFolder, filePath)
Sleep, 500
ToolTip
*/