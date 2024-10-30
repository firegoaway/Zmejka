CheckFDSCompletedSuccessfully(OutfilePath)	; Function to check if ".out" file contains "STOP: FDS completed successfully"
{
    FileRead, fileContent, %OutfilePath%
    if InStr(fileContent, "STOP: FDS completed successfully")
        return true
    else
        return false
}

CheckFDSStoppedByUser(OutfilePath)	; Function to check if ".out" file contains "STOP: FDS stopped by user"
{
    FileRead, fileContent, %OutfilePath%
    if InStr(fileContent, "STOP: FDS stopped by user")
        return true
    else
        return false
}

/*
	OutfilePath := "C:\path\to\your\file.out"

	if CheckFDSCompletedSuccessfully(OutfilePath)
	{
		MsgBox, The file contains "STOP: FDS completed successfully".
	}
	else if CheckFDSStoppedByUser(OutfilePath)
	{
		MsgBox, The file contains "STOP: FDS stopped by user".
	}
	else
	{
		MsgBox, Neither of the specified lines were found in the file.
	}
*/