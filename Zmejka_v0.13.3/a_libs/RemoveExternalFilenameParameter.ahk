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
			Line := RegExReplace(Line, "/", " BAROCLINIC=.FALSE. SUPPRESSION=.FALSE. RADIATION=.FALSE. CSMAG=0.4 PR=0.7 SC=0.7 VISCOSITY=1.8E-4/`n&PRES MAX_PRESSURE_ITERATIONS=2000 VELOCITY_TOLERANCE=500/`n&RADI RADIATIVE_FRACTION=0.45 TIME_STEP_INCREMENT=20 ANGLE_INCREMENT=10 NMIEANG=5/")
        }
		
        NewContent .= Line "`r`n"
    }
	
    FileDelete, %filePath%
    FileAppend, %NewContent%, %filePath%
}
