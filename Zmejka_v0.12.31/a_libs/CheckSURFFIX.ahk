CheckSURFFIX(filepath)
{
	check := "None"
	
    FileRead, content, %filepath%
    if ErrorLevel
	{
        MsgBox, Could not read the file. Please check the file path.
        return
    }

    Loop, Parse, content, `n, `r
    {
        line := A_LoopField

        if (SubStr(Trim(line), 1, 5) = "&SURF")
		{
            if (InStr(line, "HRRPUA") || InStr(line, "MLRPUA")) && InStr(line, "RAMP_Q")
			{
                MsgBox, 48, ZmejkaFDS, % "Пожалуйста, проведите ускоренный сценарий через SURF_FIX."
				check := 1
                return check
            }
        }
    }
	
	check := 0
	
	return check
}
