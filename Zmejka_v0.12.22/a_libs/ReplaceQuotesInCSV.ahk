ReplaceQuotesInCSV(csvfilePath)
{
    dq := Chr(34)

    File := FileOpen(csvfilePath, "r")
    If !File
    {
        MsgBox, Cannot open file for reading:`n%csvfilePath%
        ExitApp
    }

    TempFilePath := csvfilePath . ".tmp"
    TempFile := FileOpen(TempFilePath, "w")
    If !TempFile
    {
        MsgBox, Cannot create temporary file for writing:`n%TempFilePath%
        File.Close()
        ExitApp
    }

    While, !File.AtEOF
    {
        Line := File.ReadLine()
        Line := StrReplace(Line, dq dq, dq, All)
        TempFile.Write(Line "")
    }

    File.Close()
    TempFile.Close()

    FileDelete, %csvfilePath%
    FileMove, %TempFilePath%, %csvfilePath%
}

/*
FileSelectFile, SelectedFile, , , Select a CSV File, CSV Files (*.csv)

If SelectedFile =
    ExitApp

ReplaceQuotesInCSV(SelectedFile)

Return
*/
