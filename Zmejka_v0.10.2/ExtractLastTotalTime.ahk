; Function to extract the time value from the last "Total Time" line in a .out file
ExtractLastTotalTime(filePath)
{
    ; Open the file for reading
    file := FileOpen(filePath, "r")
    
    ; Check if file opened successfully
    if !IsObject(file)
    {
        ; MsgBox, Could not open file: %filePath%
        return
    }

    lastTime := 0.0  ; Initialize the last time to zero

    ; Regular expression pattern for matching "Total Time" lines
    Pattern := "Total Time:\s*(\d+(\.\d+)?)\s*s"

    ; Read the file line by line
    while !file.AtEOF()
    {
        line := file.ReadLine()
        if RegExMatch(line, Pattern, matches)
        {
            ; AHK will automatically convert this to a float in a numeric context
            lastTime := matches1

            ; Replace comma with dot if the decimal separator in your locale is a comma
            lastTime := StrReplace(lastTime, ",", ".")
        }
    }

    file.Close()  ; Close the file after reading

    return lastTime  ; Return the time value from the last "Total Time" line
}

/*
; Example usage:
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
