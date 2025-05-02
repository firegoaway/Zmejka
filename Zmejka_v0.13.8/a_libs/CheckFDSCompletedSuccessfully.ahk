CheckFDSCompletedSuccessfully(OutfilePath)
{
    FileRead, fileContent, %OutfilePath%
    if InStr(fileContent, "STOP: FDS completed successfully")
        return true
    else
        return false
}

CheckFDSStoppedByUser(OutfilePath)
{
    FileRead, fileContent, %OutfilePath%
    if InStr(fileContent, "STOP: FDS stopped by user")
        return true
    else
        return false
}
