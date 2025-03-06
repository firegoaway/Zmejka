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
			Line := RegExReplace(Line, "/", " CFL_MIN=0.001 CFL_MAX=0.999999 VN_MIN=0.3 VN_MAX=0.5 PR=0.7 SC=0.7 VISCOSITY=1.4E-4 /")
        }
		
        NewContent .= Line "`r`n"
    }
	
    FileDelete, %filePath%
    FileAppend, %NewContent%, %filePath%
}
