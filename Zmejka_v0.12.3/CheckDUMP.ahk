CheckDUMP(filePath, DT_RESTART_Value)
{
    FileRead, fileContent, %filePath%

    if InStr(fileContent, "&DUMP")
	{
        if InStr(fileContent, "DT_RESTART")	;	Check if DT_RESTART is present
		{
            fileContent := RegExReplace(fileContent, "DT_RESTART=\K[0-9]+", DT_RESTART_Value)	;	DT_RESTART is present, change its value
        }
		
		else	;	DT_RESTART is not present, add it to the &DUMP line
		{
            fileContent := RegExReplace(fileContent, "&DUMP\s*(.+)/", "&DUMP `nDT_RESTART=" DT_RESTART_Value)
        }
    }
	
	else
	{
        fileContent := "&DUMP DT_RESTART=" DT_RESTART_Value "`n" fileContent	 ;	&DUMP is not present, add the line with DT_RESTART
    }

    FileDelete, %filePath%	;	To ensure all content is overwritten
    FileAppend, %fileContent%, %filePath%	;	Rewrite the modified content back to the file
}
