Clear_FDS5_SMV(smvPath)
{
    FileRead, fileContent, %smvPath%

    StringReplace, fileContent, fileContent, _tout, , All

    StringSplit, fileLines, fileContent, `n

    keepLines := []
    
    pattern1 := "^\s*DEVC_X\d+Y\d+_MESH_\d+"
    pattern2 := "^\s*DEVICE_ACT\s+DEVC_X\d+Y\d+_MESH_\d+"

    skipCount := 0
    loop, % fileLines0
    {
        if (skipCount > 0)
        {
            skipCount--
            continue
        }
        
        currentLine := fileLines%A_Index%
        
        if (RegexMatch(currentLine, pattern1))
        {
            skipCount := 1
            keepLines.RemoveAt(keepLines.MaxIndex())
            continue
        }
        else if (RegexMatch(currentLine, pattern2))
        {
            skipCount := 1
            continue
        }
        
        keepLines.Push(currentLine)
    }
    
    newContent := ""
    for index, line in keepLines
    {
        newContent .= line "`n"
    }

    FileDelete, %smvPath%
    FileAppend, %newContent%, %smvPath%
	
	ToolTip, SMV скорректирован и отгружен в программу по расчёту пожарного риска
	Sleep, 1000
	ToolTip
}

;smvPath := "3c5b684b.smv"
;Clear_FDS5_SMV(smvPath)
