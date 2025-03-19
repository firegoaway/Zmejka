Remove_SPEC_COMB_WIND_Lines(filePath)
{
    FileRead, fileContent, %filePath%
    lines := StrSplit(fileContent, "`n")
    newContent := ""

    For index, line in lines
    {
        if (!InStr(line, "&SPEC") && !InStr(line, "&COMB") && !InStr(line, "&WIND"))
            newContent .= line "`n"
    }

    FileDelete, %filePath%
    FileAppend, %newContent%, %filePath%
	ToolTip, SPEC, COMB and WIND lines have been removed
	Sleep, 500
	ToolTip
}
