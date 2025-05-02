CheckCHID(filePath)
{
	fileName := RegExReplace(filePath, "^.*\\|\.fds$")

	FileRead, Contents, %filePath%
	If ErrorLevel
		Return False

	CurrentCHID := RegExMatch(Contents, "CHID='([^']+)'", Match)
	CurrentCHID := Match1

	If (CurrentCHID != fileName)
	{
		NC := RegExReplace(Contents, "CHID='[^']+'", "CHID='" . fileName . "'")
		
		FileDelete, %filePath%
		FileAppend, %NC%, %filePath%
		
		; MsgBox, CHID has been updated to '%fileName%' in %filePath%.
		Return True
	}
	Else
		Return True
}
