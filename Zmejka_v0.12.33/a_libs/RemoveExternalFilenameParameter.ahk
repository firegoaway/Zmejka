RemoveExternalFilenameParameter(filePath)
{
    FileRead, FileContent, %filePath%
	
    NewContent := ""
	
    Loop, Parse, FileContent, `n, `r
    {
        Line := A_LoopField
		
        if (SubStr(Trim(Line), 1, 5) = "&MISC")
		{
            Line := RegExReplace(Line, "[ ,]*EXTERNAL_FILENAME\s*=\s*'[^']*'", "")
        }
		
        NewContent .= Line "`r`n"
    }
	
    FileDelete, %filePath%
    FileAppend, %NewContent%, %filePath%
}
