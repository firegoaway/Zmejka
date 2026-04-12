GetHeatOfCombustion(filePath)
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
			    heatOfCombustionValues.Push(match1)
        }
		
		else if (SubStr(line, 1, 5) = "&REAC" && InStr(line, "EPUMO2="))
        {
            RegExMatch(line, "EPUMO2=([\d.]+)", match)
            if (match)
			    heatOfCombustionValues.Push(match1)
        }
    }

    return heatOfCombustionValues
}
