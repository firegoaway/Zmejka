CheckRestartFile(filePath)
{
    SplitPath, filePath, , dir

    searchPattern := dir . "\*.restart"

    fileList := ""
	
	restartFound := false

    Loop, Files, %searchPattern%
    {
        fileList .= A_LoopFileLongPath . "`n"
    }

    if (fileList != "")
    {
		restartFound := true
        ToolTip, Restart file(s) found at:`n %fileList%
		Sleep 1000
		ToolTip
    }
    else
    {
		restartFound := false
        ToolTip, No restart file found in the directory.
		Sleep 1000
		ToolTip
    }
	return fileList
}

AddRestartToMiscLine(filePath)
{
    FileRead, fdsContent, %filePath%

    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
	
    RegExMatch(fdsContent, "(\ RESTART=T.*\/)", restartContent)

    if ((miscLine != "") && (restartContent = ""))
	{
        modifiedLine := StrReplace(miscLine, "/", " RESTART=T/")
        StringReplace, fdsContent, fdsContent, %miscLine%, %modifiedLine%
    } 
	Else If (restartContent != "")
	{
		ToolTip, % restartContent " already exists."
		Sleep, 1000
		ToolTip
	}

    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%
	
    return ((miscLine != "") && (restartContent = "") ? 1 : 0)
}

AddRestartToMiscLineFDS5(filePath)
{
    FileRead, fdsContent, %filePath%

    RegExMatch(fdsContent, "(\&MISC.*\/)", miscLine)
	
    RegExMatch(fdsContent, "(\ RESTART=.TRUE.*\/)", restartContent)

    if ((miscLine != "") && (restartContent = ""))
	{
        modifiedLine := StrReplace(miscLine, "/", " RESTART=.TRUE./")
        StringReplace, fdsContent, fdsContent, %miscLine%, %modifiedLine%
    }
	Else If (restartContent != "")
	{
		ToolTip, % restartContent " already exists."
		Sleep, 1000
		ToolTip
	}

    FileDelete, %filePath%
    FileAppend, %fdsContent%, %filePath%
	
    return ((miscLine != "") && (restartContent = "") ? 1 : 0)
}

CheckRestartTag(filePath)
{
    FileRead, fdsContent, %filePath%
	
    RegExMatch(fdsContent, "(\&MISC[^\/]*RESTART=T[^\/]*\/)", restartContent)

    return restartContent != "" ? 1 : 0
}

CheckRestartTagFDS5(filePath)
{
    FileRead, fdsContent, %filePath%

    RegExMatch(fdsContent, "(\&MISC[^\/]*RESTART=.TRUE.[^\/]*\/)", restartContent)

    return restartContent != "" ? 1 : 0
}

RemoveRestartFromMiscLine(filePath)
{
	FileRead, fdsContent, %filePath%
  
	pattern := "\&MISC\s(.*?)(/)"

	if (RegExMatch(fdsContent, pattern, miscLine))
	{
		modifiedLine := RegExReplace(miscLine, "\sRESTART=T", "")

		fdsContent := StrReplace(fdsContent, miscLine, modifiedLine)

		FileDelete, %filePath%
		FileAppend, %fdsContent%, %filePath%

		return (miscLine && modifiedLine)
	}
	return false
}

RemoveRestartFromMiscLineFDS5(filePath)
{
	FileRead, fdsContent, %filePath%
  
	pattern := "\&MISC\s(.*?)(/)"

	if (RegExMatch(fdsContent, pattern, miscLine))
	{
		modifiedLine := RegExReplace(miscLine, "\sRESTART=.TRUE.", "")

		fdsContent := StrReplace(fdsContent, miscLine, modifiedLine)

		FileDelete, %filePath%
		FileAppend, %fdsContent%, %filePath%

		return (miscLine && modifiedLine)
	}
	return false
}