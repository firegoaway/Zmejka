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
