CheckCHID(filePath)
{
	; Extract fileName without extension
	fileName := RegExReplace(filePath, "^.*\\|\.fds$")

	; Read the file content
	FileRead, Contents, %filePath%
	If ErrorLevel
	{
		Return False
	}

	; Extract current CHID value
	CurrentCHID := RegExMatch(Contents, "CHID='([^']+)'", Match)
	CurrentCHID := Match1

	; Check if CHID matches the file name
	If (CurrentCHID != fileName)
	{
		; Replace CHID with the file name
		NC := RegExReplace(Contents, "CHID='[^']+'", "CHID='" . fileName . "'")
		
		; Write the updated content back to the file
		FileDelete, %filePath% ; Need to delete the existing file first
		FileAppend, %NC%, %filePath%
		
		; MsgBox, CHID has been updated to '%fileName%' in %filePath%.
		Return True
	}
	Else
	{
		; MsgBox, CHID already matches the file name.
		Return True
	}
}
