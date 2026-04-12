SearchForTEND(fdsFilePath)
{
    File := FileOpen(fdsFilePath, "r")

    if !IsObject(File)
	{
        MsgBox, "Could not open .fds file."
        return
    }

    FDSText := File.Read()
    File.Close()
    RegexMatch(FDSText, "T_END\s*=\s*(\d+)", T_ENDMatch)
    T_ENDValue := T_ENDMatch1

    if (T_ENDValue = "")
	{
        MsgBox, "T_END value not found in the .fds file."
        return
    }

	Return T_ENDValue
}

