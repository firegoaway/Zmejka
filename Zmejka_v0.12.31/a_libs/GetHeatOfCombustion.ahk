﻿GetHeatOfCombustion(filePath)
{
    local heatOfCombustionValues := []
    FileRead, fileContent, %filePath%
    
    Loop, parse, fileContent, `n
    {
        line := A_LoopField
        
        if (SubStr(line, 1, 5) = "&REAC" && InStr(line, "HEAT_OF_COMBUSTION="))
        {
            RegExMatch(line, "HEAT_OF_COMBUSTION=([\d.]+)", match)
            
            if (match)
            {
			heatOfCombustionValues.Push(match1)
            }
        }
    }

    return heatOfCombustionValues
}

/*
	for index, value in heatValues
	{
		MsgBox, % "HEAT_OF_COMBUSTION Value " index ": " value
	}
*/