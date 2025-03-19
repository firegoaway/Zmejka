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
        fileContent := "&DUMP DT_RESTART=" DT_RESTART_Value fileContent	;" COLUMN_DUMP_LIMIT=.FALSE." fileContent	; &DUMP is not present, add the line with DT_RESTART and COLUMN_DUMP_LIMIT

    FileDelete, %filePath%	; To ensure all content is overwritten
    FileAppend, %fileContent%, %filePath%	; Rewrite the modified content back to the file
}
