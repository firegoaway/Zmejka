CheckDUMP(filePath, DT_RESTART_Value)
{
    
	FileRead, fileContent, %filePath%

    if InStr(fileContent, "&DUMP")
    {
        if InStr(fileContent, "DT_RESTART")
            fileContent := RegExReplace(fileContent, "DT_RESTART=\K[0-9]+", DT_RESTART_Value)
        else
            fileContent := RegExReplace(fileContent, "&DUMP\s*(.+)/", "&DUMP DT_RESTART=" DT_RESTART_Value) ;" COLUMN_DUMP_LIMIT=.FALSE./")
    }
    else
        fileContent := "&DUMP DT_RESTART=" DT_RESTART_Value fileContent	;" COLUMN_DUMP_LIMIT=.FALSE." fileContent	; Если строчки &DUMP нет, добавляем сразу DT_RESTART и COLUMN_DUMP_LIMIT

    FileDelete, %filePath%	; Убеждаемся, что все содержимое перезаписывается
    FileAppend, %fileContent%, %filePath%	; Перезаписываем содержимое обратно в файл
}

CheckFFB(filePath, FLUSH_FILE_BUFFERS_STATE)
{
    FileRead, fileContent, %filePath%

    if InStr(fileContent, "&DUMP")
    {
        if InStr(fileContent, "FLUSH_FILE_BUFFERS")
            ; Заменяем значение FLUSH_FILE_BUFFERS, сохраняя имя параметра
            fileContent := RegExReplace(fileContent, "(FLUSH_FILE_BUFFERS=)\.[a-zA-Z]+\.", "$1" FLUSH_FILE_BUFFERS_STATE)
        else
            ; Добавляем FLUSH_FILE_BUFFERS к существующей строке &DUMP, сохраняя другие параметры и добавляя закрывающий /
            fileContent := RegExReplace(fileContent, "(&DUMP\s*)(.+?)(\s*/)", "$1$2 FLUSH_FILE_BUFFERS=" FLUSH_FILE_BUFFERS_STATE "$3")
    }
    else
        ; Добавляем новую строку &DUMP с FLUSH_FILE_BUFFERS и правильным закрывающим /
        fileContent := "&DUMP FLUSH_FILE_BUFFERS=" FLUSH_FILE_BUFFERS_STATE "/`r`n" fileContent

    FileDelete, %filePath%
    FileAppend, %fileContent%, %filePath%
}
