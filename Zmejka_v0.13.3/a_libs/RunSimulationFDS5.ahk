RunSimulationFDS5(filePath, dir)
{
	execPath := A_ScriptDir "..\FDS5\fds5_mpi_win_64.exe"
	SetWorkingDir, %dir%

    Run, "%execPath%" "%filePath%", "%dir%", , PID
}

Proceed_Renaming(directory, filePath)
{
    SplitPath, filePath, fileName, dir
	StringReplace, fileName, fileName, _nfs.fds, , All
	SetWorkingDir, %dir%
	
    Loop, Files, % directory "\" fileName "*.*"
    {
        FullFilePath := A_LoopFileFullPath
        FileName := A_LoopFileName
        FileExt := A_LoopFileExt
		
		if (FileExt = "q")
            continue
		
		if (FileExt = "sf")
		{
            ;continue
        }
        
        NameParts := StrSplit(FileName, "_")
        CleanFileName := ""
        
        Loop, % NameParts.MaxIndex()
        {
            Part := NameParts[A_Index]
            CleanPart := RegExReplace(Part, "^(0+)(\d)", "$2")
            CleanFileName .= (A_Index = 1 ? "" : "_") . CleanPart
        }
        
        if (FileExt = "bf")
		{
            ;CleanFileName := RegExReplace(CleanFileName, "\.bf$", ".bnd")
        }
        
        NewFilePath := directory "\" CleanFileName
        
        if (FullFilePath != NewFilePath)
            FileMove, %FullFilePath%, %NewFilePath%
    }
}
