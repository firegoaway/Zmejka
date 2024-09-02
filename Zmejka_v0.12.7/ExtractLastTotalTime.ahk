ExtractLastTotalTime(filePath)
{
    file := FileOpen(filePath, "r")
    
    if !IsObject(file)
    {
        ; MsgBox, Не удаётся открыть файл: %filePath%
        return
    }

    lastTime := 0.0

    Pattern := "(?i)Total Time:\s*(\d+(\.\d+)?)\s*s"

    while !file.AtEOF()
    {
        line := file.ReadLine()
        if RegExMatch(line, Pattern, matches)
        {
            lastTime := matches1

            lastTime := StrReplace(lastTime, ",", ".")
        }
    }

    file.Close()

    return lastTime
}

/*
OutfilePath := "E:\FIREGOAWAY\GitHub\Zmejka\Zmejka_v0.9.3\605dccfa.out"
LastTotalTime := ExtractLastTotalTime(OutfilePath)
MsgBox, The time value from the last "Total Time" line is: %LastTotalTime% seconds
*/

/*
OutfilePath := "E:\FIREGOAWAY\GitHub\Zmejka\Zmejka_v0.9.3\605dccfa.out"
Loop
{
	TEND := 120
	TotalTime := Ceil(ExtractLastTotalTime(OutfilePath))
	ToolTip, % TotalTime "/" TEND
		Sleep, 100
	ToolTip
	ProgressPercentage := Ceil((TotalTime / TEND) * 100)
	Progress, %ProgressPercentage%
		Sleep, 100
} Until (TotalTime >= TEND)
Progress Off
*/
