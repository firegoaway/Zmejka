UnCheckDUMP(filePath)
{
    FileRead, fileContent, %filePath%
    
    if InStr(fileContent, "&DUMP")
	{
        if InStr(fileContent, "DT_RESTART")
		{
            fileContent := RegExReplace(fileContent, "DT_RESTART=\K[0-9]+", 100000)
        }
		
		else
		{
            fileContent := RegExReplace(fileContent, "&DUMP\s*(.+)/", "&DUMP `nDT_RESTART=" 100000)
        }
    }
	
	else
	{
        fileContent := "&DUMP DT_RESTART=" 100000 "`n" fileContent
    }

    FileDelete, %filePath%	;	To ensure all content is overwritten
    FileAppend, %fileContent%, %filePath%
}
