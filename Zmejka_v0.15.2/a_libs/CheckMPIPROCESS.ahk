CheckMPIPROCESS(filepath)
{
    FileRead, content, %filepath%
    if ErrorLevel {
        MsgBox, Could not read the file (CheckMPIPROCESS).
        return
    }
    
    lines := StrSplit(content, "`n", "`r")
    newLines := []
    
    for index, line in lines {
        if (RegExMatch(line, "^\s*\&MESH")) {
            ; Удаляем параметр MPI_PROCESS и форматируем строку &MESH
            newLine := RegExReplace(line, "\s*MPI_PROCESS=[^\s/]*", "")
            newLine := RegExReplace(newLine, "[ \t]+", " ")  ; Устраняем мультипробелы
            newLine := RTrim(newLine)  ; Удаляем конечные пробелы
            newLines.Push(newLine)
        } else {
            newLines.Push(line)
        }
    }
    
    ; Ребилдим
    newContent := ""
    for index, line in newLines {
        newContent .= (index = 1 ? "" : "`r`n") . line
    }
    
    ; Запись
    FileDelete, %filepath%
    FileAppend, %newContent%, %filepath%
    if ErrorLevel {
        MsgBox, Could not write to the file (CheckMPIPROCESS).
    } else {
        ToolTip, Параметр MPI_PROCESS успешно очищен.
    }
}